import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var tonicConductor: ViewConductor
    @ObservedObject var modeConductor: ViewConductor
    @Binding var showTonicPicker: Bool
    
    var body: some View {
        HStack {
            HStack(spacing: 0.0) {
                OctaveShiftView(viewConductor: viewConductor, tonicConductor: tonicConductor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            TonicPickerSettingsView(tonicConductor: tonicConductor, modeConductor: modeConductor, showTonicPicker: $showTonicPicker)
            HStack(spacing: 15) {
                PitchDirectionPickerView()
                HelpView(viewConductor: viewConductor)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
