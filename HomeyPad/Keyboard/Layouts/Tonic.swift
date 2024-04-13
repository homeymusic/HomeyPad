// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

struct Tonic<Content>: View where Content: View {
    let keyboardKey: (Pitch) -> Content
    
    @StateObject var tonicConductor: ViewConductor
    
    var body: some View {
        let midiRange: ClosedRange<Int> = switch tonicConductor.pitchDirection {
        case .downward:
            tonicConductor.tonicMIDI - 12 ... tonicConductor.tonicMIDI
        default:
            tonicConductor.tonicMIDI ... tonicConductor.tonicMIDI + 12
        }
        HStack(spacing: 0) {
            ForEach(midiRange, id: \.self) { midi in
                if safeMIDI(midi: midi) {
                    KeyContainer(conductor: tonicConductor,
                                 pitch: tonicConductor.allPitches[midi],
                                 keyboardKey: keyboardKey)
                } else {
                    Color.clear
                }
            }
        }
        .animation(tonicConductor.animationStyle, value: tonicConductor.tonicMIDI)
        .clipShape(Rectangle())
    }
}
