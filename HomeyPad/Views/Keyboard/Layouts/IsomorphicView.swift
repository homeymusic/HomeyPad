import SwiftUI
import MIDIKitCore
import HomeyMusicKit

struct IsomorphicView<Content>: View where Content: View {
    let pitchView: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var tonalContext: TonalContext

    var body: some View {
        VStack(spacing: 0) {
            let rows = viewConductor.layoutRows

            ForEach(rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(viewConductor.layoutCols, id: \.self) { col in
                        let linearIndex: Int = Int(col) + 12 * Int(row)
                        Group {
                            if Pitch.isValid(linearIndex) {
                                let pitch = tonalContext.pitch(for: MIDINoteNumber(linearIndex))
                                PitchContainerView(
                                    conductor: viewConductor,
                                    pitch: pitch,
                                    pitchView: pitchView
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
