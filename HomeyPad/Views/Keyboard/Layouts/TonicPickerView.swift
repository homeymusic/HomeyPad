import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct TonicPickerView<Content>: View where Content: View {
    let pitchView: (Pitch) -> Content
    
    @StateObject private var tonalContext = TonalContext.shared
    @ObservedObject var tonicConductor: ViewConductor
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tonalContext.tonicPickerNotes, id: \.self) { note in
                if Pitch.isValidPitch(note) {
                    PitchContainerView(conductor: tonicConductor,
                                             pitch: Pitch.pitch(for: MIDINoteNumber(note)),
                                             pitchView: pitchView)
                } else {
                    Color.clear
                }
            }
        }
        .animation(tonicConductor.animationStyle, value: tonalContext.tonicMIDI)
        .clipShape(Rectangle())
    }
}
