import SwiftUI
import HomeyMusicKit

struct TonicPickerView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    
    @ObservedObject var tonicConductor: ViewConductor
    
    var body: some View {
        let midiRange: ClosedRange<Int> = switch tonicConductor.pitchDirection {
        case .downward:
            Int(tonicConductor.tonicPitch.midi) - 12 ... Int(tonicConductor.tonicPitch.midi)
        default:
            Int(tonicConductor.tonicPitch.midi) ... Int(tonicConductor.tonicPitch.midi) + 12
        }
        HStack(spacing: 0) {
            ForEach(midiRange, id: \.self) { midi in
                if safeMIDI(midi: midi) {
                    KeyboardKeyContainerView(conductor: tonicConductor,
                                             pitch: Pitch.allPitches[midi],
                                             keyboardKeyView: keyboardKeyView)
                } else {
                    Color.clear
                }
            }
        }
        .animation(tonicConductor.animationStyle, value: tonicConductor.tonicMIDI)
        .clipShape(Rectangle())
    }
}
