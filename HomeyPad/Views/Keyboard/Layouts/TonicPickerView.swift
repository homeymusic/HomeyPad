import SwiftUI
import HomeyMusicKit

struct TonicPickerView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    
    @StateObject private var tonalContext = TonalContext.shared
    @ObservedObject var tonicConductor: ViewConductor
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tonalContext.tonicRegisterNotes, id: \.self) { note in
                if MIDIHelper.isValidMIDI(note: note) {
                    KeyboardKeyContainerView(conductor: tonicConductor,
                                             pitch: tonalContext.allPitches[note],
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
