// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

struct Strings<Content>: View where Content: View {
    let keyboardKey: (Pitch) -> Content
    var keyboardModel: KeyboardModel
    @StateObject var viewConductor: ViewConductor

    let fretCount: Int = 22
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< viewConductor.openStringsMIDI.count, id: \.self) { string in
                HStack(spacing: 0) {
                    ForEach(0 ..< fretCount + 1, id: \.self) { fret in
                        if (viewConductor.stringsLayoutChoice == .banjo && string == 4 && fret < 5) {
                            Color.clear
                        } else {
                            let midi = viewConductor.openStringsMIDI[string] + fret
                            let pitch = viewConductor.allPitches[midi]
                            KeyContainer(keyboardModel: keyboardModel,
                                         pitch: pitch,
                                         keyboardKey: keyboardKey)
                        }
                    }
                }
            }
        }
        .clipShape(Rectangle())
    }
}
