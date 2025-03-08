import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct TonicPickerView: View {
    @ObservedObject var tonicConductor: ViewConductor
    
    @EnvironmentObject var tonalContext: TonalContext
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tonalContext.tonicPickerNotes, id: \.self) { note in
                if Pitch.isValid(note) {
                    PitchContainerView(conductor: tonicConductor,
                                       pitch: tonalContext.pitch(for: MIDINoteNumber(note)))
                } else {
                    Color.clear
                }
            }
        }
        .animation(tonicConductor.animationStyle, value: tonalContext.tonicMIDI)
        .clipShape(Rectangle())
    }
}
