import SwiftUI
import HomeyMusicKit

struct TonicPickerView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    
    @ObservedObject var tonicConductor: ViewConductor
    
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
                    KeyboardKeyContainerView(conductor: tonicConductor,
                                 pitch: tonicConductor.allPitches[midi],
                                 keyboardKey: keyboardKeyView)
                } else {
                    Color.clear
                }
            }
        }
        .animation(tonicConductor.animationStyle, value: tonicConductor.tonicMIDI)
        .clipShape(Rectangle())
    }
}
