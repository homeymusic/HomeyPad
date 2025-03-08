import SwiftUI
import MIDIKitCore
import HomeyMusicKit

struct IsomorphicView: View {
    @ObservedObject var viewConductor: ViewConductor
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
                                    conductor: viewConductor,
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
        .animation(viewConductor.animationStyle, value: tonalContext.tonicMIDI)
        .clipShape(Rectangle())
    }
}
