// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

struct Tonic<Content>: View where Content: View {
    let keyboardKey: (Pitch) -> Content
    var tonicKeyboardModel: TonicKeyboardModel

    @StateObject var tonicConductor: ViewConductor

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tonicConductor.tonicMIDI ... tonicConductor.tonicMIDI + 12, id: \.self) { midi in
                if midi < 0 || midi > 127 {
                    Color.clear
                } else {
                    KeyContainer(keyboardModel: tonicKeyboardModel,
                                 pitch: tonicConductor.allPitches[midi],
                                 keyboardKey: keyboardKey)
                }
            }
        }
        .clipShape(Rectangle())
    }
}
