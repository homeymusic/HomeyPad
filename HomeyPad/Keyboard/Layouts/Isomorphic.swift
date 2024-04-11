// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

struct Isomorphic<Content>: View where Content: View {
    let keyboardKey: (Pitch) -> Content
    var keyboardModel: KeyboardModel
    @StateObject var viewConductor: ViewConductor

    var body: some View {
        HStack(spacing: 0) {
            ForEach(viewConductor.lowMIDI...viewConductor.highMIDI, id: \.self) { midi in
                if midi < 0 || midi > 127 {
                    Color.clear
                } else {
                    KeyContainer(keyboardModel: keyboardModel,
                                 pitch: viewConductor.allPitches[midi],
                                 keyboardKey: keyboardKey)
                }
            }
        }
        .clipShape(Rectangle())
    }
}
