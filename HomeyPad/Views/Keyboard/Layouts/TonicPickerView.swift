import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct TonicPickerView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    
    @StateObject private var tonalContext = TonalContext.shared
    @ObservedObject var tonicConductor: ViewConductor
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tonalContext.tonicRegisterNotes, id: \.self) { note in
                if MIDIConductor.isValidMIDI(note) {
                    KeyboardKeyContainerView(conductor: tonicConductor,
                                             pitch: Pitch.pitch(for: MIDINoteNumber(note)),
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
