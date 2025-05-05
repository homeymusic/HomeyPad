import SwiftUI
import HomeyMusicKit

struct HeaderView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppContext.self) private var appContext

    // pull your instrument once
    private var musicalInstrument: MusicalInstrument {
        // force-cast because we know all of your concrete models
        modelContext.singletonInstrument(for: appContext.instrumentType)
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 15) {
                ResetView(instrument: musicalInstrument)
                OctaveShiftView(instrument: musicalInstrument)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            TonicModePickerNotationView(
                tonalityInstrument: modelContext.tonalityInstrument()
            )
            HStack(spacing: 15) {
                PitchDirectionPickerView(tonality: musicalInstrument.tonality)
                HelpView()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
