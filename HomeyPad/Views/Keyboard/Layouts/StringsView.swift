import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct StringsView<Content>: View where Content: View {
    let pitchView: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor
    @StateObject private var tonalContext = TonalContext.shared

    let fretCount: Int = 22
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< viewConductor.openStringsMIDI.count, id: \.self) { string in
                HStack(spacing: 0) {
                    ForEach(0 ..< fretCount + 1, id: \.self) { fret in
                        if (viewConductor.stringsLayoutChoice == .banjo && string == 4 && fret < 5) {
                            Color.clear
                        } else {
                            let note = viewConductor.openStringsMIDI[string] + fret
                            if (Pitch.isValidPitch(note)) {
                                let pitch = Pitch.pitch(for: MIDINoteNumber(note))
                                PitchContainerView(conductor: viewConductor,
                                                         pitch: pitch,
                                                         pitchView: pitchView)
                            } else {
                                Color.clear
                            }
                        }
                    }
                }
            }
        }
        .animation(viewConductor.animationStyle, value: tonalContext.tonicMIDI)
        .clipShape(Rectangle())
    }
}
