// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

struct Strings<Content>: View where Content: View {
    let content: (Pitch) -> Content
    var model: KeyboardModel
    @StateObject var viewConductor: ViewConductor

    let fretCount: Int = 22
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< viewConductor.openStringsMIDI.count, id: \.self) { string in
                HStack(spacing: 0) {
                    ForEach(0 ..< fretCount + 1, id: \.self) { fret in
                        let midi = viewConductor.openStringsMIDI[string] + fret
                        let pitch = viewConductor.allPitches[midi]
                        KeyContainer(model: model,
                                     pitch: pitch,
                                     tonicPitch: viewConductor.tonicPitch,
                                     content: content)
                    }
                }
            }
        }
        .clipShape(Rectangle())
    }
}
