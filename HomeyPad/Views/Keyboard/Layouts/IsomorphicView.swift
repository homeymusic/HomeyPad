import SwiftUI
import MIDIKitCore
import HomeyMusicKit

struct IsomorphicView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor
    @StateObject private var tonalContext = TonalContext.shared

    var body: some View {
        VStack(spacing: 0) {
            let rows = (-viewConductor.layoutRowsCols.rowsPerSide[.isomorphic]! ... viewConductor.layoutRowsCols.rowsPerSide[.isomorphic]!).reversed()

            ForEach(rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(viewConductor.layoutNotes, id: \.self) { col in
                        let linearIndex: Int = Int(col) + 12 * Int(row)
                        Group {
                            if Pitch.isValidPitch(linearIndex) {
                                let pitch = Pitch.pitch(for: MIDINoteNumber(linearIndex))
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
        .animation(viewConductor.animationStyle, value: tonalContext.tonicMIDI)
        .clipShape(Rectangle())
    }
}
