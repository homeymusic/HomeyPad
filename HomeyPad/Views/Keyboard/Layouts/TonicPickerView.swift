import SwiftUI
import HomeyMusicKit

struct TonicPickerView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    
    @StateObject private var tonalContext = TonalContext.shared
    @ObservedObject var tonicConductor: ViewConductor
    
    var body: some View {
        let midiRange = tonalContext.midiRange
        
        HStack(spacing: 0) {
            ForEach(midiRange, id: \.self) { midi in
                if tonalContext.safeMIDI(midi: midi) {
                    KeyboardKeyContainerView(conductor: tonicConductor,
                                             pitch: tonalContext.allPitches[midi],
                                             keyboardKeyView: keyboardKeyView)
                } else {
                    Color.clear
                }
            }
        }
        .animation(tonicConductor.animationStyle, value: tonalContext.tonicMIDI)
        .clipShape(Rectangle())
    }
}
