// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

struct Tonic<Content>: View where Content: View {
    let keyboardKey: (Pitch) -> Content
    var keyboardModel: KeyboardModel
    @StateObject var tonicConductor: ViewConductor

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tonicConductor.centerMIDI - 6 ... tonicConductor.centerMIDI + 6, id: \.self) { midi in
                if midi < 0 || midi > 127 {
                    Color.clear
                } else {
                    KeyContainer(keyboardModel: keyboardModel,
                                 pitch: tonicConductor.allPitches[midi],
                                 conductor: tonicConductor,
                                 keyboardKey: keyboardKey)
                }
            }
        }
        .clipShape(Rectangle())
    }
}
