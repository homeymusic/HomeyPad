// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

struct Isomorphic<Content>: View where Content: View {
    let content: (Pitch, Pitch, Bool) -> Content
    var model: KeyboardModel
    var pitches: ArraySlice<Pitch>
    var tonicPitch: Pitch

    var body: some View {
        HStack(spacing: 0) {
            ForEach(pitches, id: \.self) { pitch in
                KeyContainer(model: model,
                             pitch: pitch,
                             tonicPitch: tonicPitch,
                             content: content)
            }
        }
        .clipShape(Rectangle())
    }
}
