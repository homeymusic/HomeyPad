// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

struct Isomorphic<Content>: View where Content: View {
    let content: (Pitch, Pitch) -> Content
    var model: KeyboardModel
    var allPitches: [Pitch]
    var tonicPitch: Pitch
    var lowMIDI: Int
    var highMIDI: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(lowMIDI...highMIDI, id: \.self) { midi in
                if midi < 0 || midi > 127 {
                    Color.clear
                } else {
                    KeyContainer(model: model,
                                 pitch: allPitches[midi],
                                 tonicPitch: tonicPitch,
                                 content: content)
                }
            }
        }
        .clipShape(Rectangle())
    }
}
