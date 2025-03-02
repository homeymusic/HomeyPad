import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct TonicPickerView<Content>: View where Content: View {
    let pitchView: (Pitch) -> Content    
    @ObservedObject var tonicConductor: ViewConductor
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tonicConductor.tonalContext.tonicPickerNotes, id: \.self) { note in
                if Pitch.isValid(note) {
                    PitchContainerView(conductor: tonicConductor,
                                       pitch: tonicConductor.tonalContext.pitch(for: MIDINoteNumber(note)),
                                       pitchView: pitchView)
                } else {
                    Color.clear
                }
            }
        }
        .animation(tonicConductor.animationStyle, value: tonicConductor.tonalContext.tonicMIDI)
        .clipShape(Rectangle())
    }
}
