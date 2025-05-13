import SwiftUI
import HomeyMusicKit

struct HeaderView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppContext.self) private var appContext
    @Environment(SynthConductor.self) private var synthConductor
    @Environment(MIDIConductor.self)  private var midiConductor

    private var musicalInstrument: MusicalInstrument {
        modelContext.singletonInstrument(
            for: appContext.instrumentType,
            midiConductor: midiConductor,
            synthConductor: synthConductor
        )
    }

    var body: some View {
        HStack {
            HStack(spacing: 15) {
                ResetterView(modelContext.tonalityInstrument(midiConductor: midiConductor))
                OctaveShifterView(modelContext.tonalityInstrument(midiConductor: midiConductor))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            TonicModePickerNotationView(
                tonalityInstrument: modelContext.tonalityInstrument(midiConductor: midiConductor)
            )
            HStack(spacing: 15) {
                PitchDirectionPickerView(modelContext.tonalityInstrument(midiConductor: midiConductor))
                HelpView()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
