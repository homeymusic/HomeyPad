import SwiftUI
import HomeyMusicKit

struct HeaderView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppContext.self) private var appContext

    // pull your instrument once
    private var instrument: Instrument {
        // force-cast because we know all of your concrete models
        modelContext
          .instrument(for: appContext.instrumentChoice)
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 15) {
                ResetView(instrument: instrument)
                OctaveShiftView(instrument: instrument)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            TonicModePickerNotationView()
            HStack(spacing: 15) {
                PitchDirectionPickerView(tonality: instrument.tonality)
                HelpView()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
