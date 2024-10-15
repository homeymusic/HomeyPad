import SwiftUI
import HomeyMusicKit

struct IsomorphicView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach((-viewConductor.layoutRowsCols.rowsPerSide[.isomorphic]!...viewConductor.layoutRowsCols.rowsPerSide[.isomorphic]!).reversed(), id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(viewConductor.lowMIDI...viewConductor.highMIDI, id: \.self) { col in
                        let midi: Int = col + 12 * row
                        if TonalContext.shared.safeMIDI(midi: midi) {
                            KeyboardKeyContainerView(conductor: viewConductor,
                                                     pitch: TonalContext.shared.allPitches[midi],
                                                     keyboardKeyView: keyboardKeyView)
                        } else {
                            Color.clear
                        }
                    }
                }
            }
        }
        .animation(viewConductor.animationStyle, value: TonalContext.shared.tonicPitch.midi)
        .clipShape(Rectangle())
    }
}
