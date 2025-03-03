import SwiftUI
import HomeyMusicKit

struct HeaderView: View {
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var tonicConductor: ViewConductor
    @ObservedObject var modeConductor: ViewConductor
    @ObservedObject var tonalContext: TonalContext
    
    @Binding var showTonicPicker: Bool
    
    var body: some View {
        HStack {
            HStack(spacing: 0.0) {
                OctaveShiftView(tonicConductor: tonicConductor, tonalContext: tonalContext)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            TonicPickerSettingsView(
                tonicConductor: tonicConductor,
                modeConductor: modeConductor,
                tonalContext: tonalContext,
                showTonicPicker: $showTonicPicker)
            HStack(spacing: 15) {
                PitchDirectionPickerView(
                    tonicConductor: tonicConductor,
                    tonalContext: tonalContext
                )
                HelpView(viewConductor: viewConductor)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
