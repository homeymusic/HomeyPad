import SwiftUI
import MIDIKitCore
import HomeyMusicKit

struct TonnetzView: View {
    @ObservedObject var tonnetz: Tonnetz

    @EnvironmentObject var tonalContext: TonalContext

    var body: some View {
        VStack(spacing: 0) {
            ForEach(tonnetz.rowIndices, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(tonnetz.colIndices(forTonic: Int(tonalContext.tonicPitch.midiNote.number),
                                                          pitchDirection: tonalContext.pitchDirection), id: \.self) { col in
                        let linearIndex: Int = Int(col) + 12 * Int(row)
                        Group {
                            if Pitch.isValid(linearIndex) {
                                let pitch = tonalContext.pitch(for: MIDINoteNumber(linearIndex))
                                PitchContainerView(
                                    pitch: pitch
                                )
                            } else {
                                Color.clear
                            }
                        }
                    }
                }
            }
        }
        .animation(HomeyPad.animationStyle, value: tonalContext.tonicMIDI)
        .clipShape(Rectangle())
    }
}
