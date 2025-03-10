import SwiftUI
import MIDIKitCore
import HomeyMusicKit

struct IsomorphicView: View {
    @ObservedObject var isomorphic: Isomorphic

    @EnvironmentObject var tonalContext: TonalContext

    var body: some View {
        VStack(spacing: 0) {
            ForEach(isomorphic.rowIndices, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(isomorphic.colIndices(forTonic: Int(tonalContext.tonicPitch.midiNote.number),
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
