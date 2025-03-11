import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct TonicPickerView: View {
    @EnvironmentObject var tonalContext: TonalContext
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tonalContext.tonicPickerNotes, id: \.self) { note in
                if Pitch.isValid(note) {
                    PitchContainerView(
                        pitch: tonalContext.pitch(for: MIDINoteNumber(note)),
                        containerType: .tonicPicker
                    )
                } else {
                    Color.clear
                }
            }
        }
        .animation(HomeyPad.animationStyle, value: tonalContext.tonicMIDI)
        .clipShape(Rectangle())
    }
}
