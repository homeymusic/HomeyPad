import SwiftUI
import HomeyMusicKit

struct TonicPickerView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    
    @ObservedObject var tonicConductor: ViewConductor
    
    var body: some View {
        let midiRange = TonalContext.shared.midiRange()
        
        HStack(spacing: 0) {
            ForEach(midiRange, id: \.self) { midi in
                if TonalContext.shared.safeMIDI(midi: midi) {
                    KeyboardKeyContainerView(conductor: tonicConductor,
                                             pitch: TonalContext.shared.allPitches[midi],
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
