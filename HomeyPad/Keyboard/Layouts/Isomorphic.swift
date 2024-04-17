// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

struct Isomorphic<Content>: View where Content: View {
    let keyboardKey: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor

    var body: some View {
        VStack(spacing: 0) {
            ForEach((-viewConductor.layoutRowsCols.rowsPerSide[.isomorphic]!...viewConductor.layoutRowsCols.rowsPerSide[.isomorphic]!).reversed(), id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(viewConductor.lowMIDI...viewConductor.highMIDI, id: \.self) { col in
                        let midi: Int = col + 12 * row
                        if safeMIDI(midi: midi) {
                            KeyContainer(conductor: viewConductor,
                                         pitch: viewConductor.allPitches[midi],
                                         keyboardKey: keyboardKey)
                        } else {
                            Color.clear
                        }
                    }
                }
            }
        }
        .animation(viewConductor.animationStyle, value: viewConductor.tonicMIDI)
        .clipShape(Rectangle())
    }
}
