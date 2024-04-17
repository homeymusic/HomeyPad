import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var tonicConductor: ViewConductor
    @Binding var showTonicPicker: Bool
    
    var body: some View {
        HStack {
            HStack(spacing: 0.0) {
                OctaveShiftView(viewConductor: viewConductor, tonicConductor: tonicConductor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            TonicPickerSettingsView(tonicConductor: tonicConductor, showTonicPicker: $showTonicPicker)
            HStack(spacing: 15) {
                PitchDirectionPickerView(viewConductor: viewConductor, tonicConductor: tonicConductor)
                HelpView(viewConductor: viewConductor)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
