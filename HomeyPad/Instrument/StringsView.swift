import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct StringsView<Content>: View where Content: View {
    let pitchView: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor
    @EnvironmentObject var tonalContext: TonalContext
    @ObservedObject var stringInstrument: StringInstrument

    let fretCount: Int = 22
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< stringInstrument.openStringsMIDI.count, id: \.self) { string in
                HStack(spacing: 0) {
                    ForEach(0 ..< fretCount + 1, id: \.self) { fret in
                        if (stringInstrument.instrumentType == .banjo && string == 4 && fret < 5) {
                            Color.clear
                        } else {
                            let note = stringInstrument.openStringsMIDI[string] + fret
                            if (Pitch.isValid(note)) {
                                let pitch = tonalContext.pitch(for: MIDINoteNumber(note))
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
