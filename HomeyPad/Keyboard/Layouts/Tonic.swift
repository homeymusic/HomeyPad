// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

struct Tonic<Content>: View where Content: View {
    let content: (Pitch) -> Content
    var model: KeyboardModel
    @StateObject var viewConductor: ViewConductor

    var body: some View {
        HStack(spacing: 0) {
            ForEach(viewConductor.centerMIDI - 6...viewConductor.centerMIDI + 6, id: \.self) { midi in
                if midi < 0 || midi > 127 {
                    Color.clear
                } else {
                    KeyContainer(model: model,
                                 pitch: viewConductor.allPitches[midi],
                                 tonicPitch: viewConductor.tonicPitch,
                                 content: content)
                }
            }
        }
        .clipShape(Rectangle())
    }
}
