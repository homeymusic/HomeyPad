// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

struct Guitar<Content>: View where Content: View {
    let content: (Pitch, Pitch, Bool) -> Content
    var model: KeyboardModel
    var allPitches: [Pitch]
    var tonicPitch: Pitch
    var openStringsMIDI: [Int]
    var fretCount: Int

    var body: some View {
        // Loop through the keys and add rows (strings)
        // Each row has a 5 note offset tuning them to 4ths
        VStack(spacing: 0) {
            ForEach(0 ..< openStringsMIDI.count, id: \.self) { string in
                HStack(spacing: 0) {
                    ForEach(0 ..< fretCount + 1, id: \.self) { fret in
                        KeyContainer(model: model,
                                     pitch: allPitches[openStringsMIDI[string] + fret],
                                     tonicPitch: tonicPitch,
                                     content: content)
                    }
                }
            }
        }
        .clipShape(Rectangle())
    }
}
