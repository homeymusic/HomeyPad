import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct StringsView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
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
                            if (MIDIConductor.isValidMIDI(note: note)) {
                                let pitch = Pitch.pitch(for: MIDINoteNumber(note))
                                KeyboardKeyContainerView(conductor: viewConductor,
                                                         pitch: pitch,
                                                         keyboardKeyView: keyboardKeyView)
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
