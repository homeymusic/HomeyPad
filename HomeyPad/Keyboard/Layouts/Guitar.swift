// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

struct Guitar<Content>: View where Content: View {
    let content: (Pitch) -> Content
    var model: KeyboardModel
    @StateObject var viewConductor: ViewConductor

    let openStringsMIDI: [Int8] = [64, 59, 55, 50, 45, 40]

    let fretCount: Int = 22
    
    var body: some View {
        // Loop through the keys and add rows (strings)
        // Each row has a 5 note offset tuning them to 4ths
        VStack(spacing: 0) {
            ForEach(0 ..< openStringsMIDI.count, id: \.self) { string in
                HStack(spacing: 0) {
                    ForEach(0 ..< fretCount + 1, id: \.self) { fret in
                        KeyContainer(model: model,
                                     pitch: viewConductor.allPitches[Int(openStringsMIDI[string]) + fret],
                                     tonicPitch: viewConductor.tonicPitch,
                                     content: content)
                    }
                }
            }
        }
        .clipShape(Rectangle())
    }
}
