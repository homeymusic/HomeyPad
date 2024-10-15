import SwiftUI
import HomeyMusicKit

struct IsomorphicView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor

    var body: some View {
        VStack(spacing: 0) {
            let rows = (-viewConductor.layoutRowsCols.rowsPerSide[.isomorphic]! ... viewConductor.layoutRowsCols.rowsPerSide[.isomorphic]!).reversed()
            let midiRange = viewConductor.lowMIDI...viewConductor.highMIDI

            ForEach(rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(midiRange, id: \.self) { col in
                        let unSureMIDI: Int = Int(col) + 12 * Int(row)
                        let pitch = TonalContext.shared.pitch(for: Int8(unSureMIDI))
                        
                        Group {
                            if TonalContext.shared.safeMIDI(midi: unSureMIDI) {
                                KeyboardKeyContainerView(
                                    conductor: viewConductor,
                                    pitch: pitch,
                                    keyboardKeyView: keyboardKeyView
                                )
                            } else {
                                Color.clear
                            }
                        }
                    }
                }
            }
        }
        .animation(viewConductor.animationStyle, value: TonalContext.shared.tonicMIDI)
        .clipShape(Rectangle())
    }
}
