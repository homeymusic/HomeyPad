import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var tonicConductor: ViewConductor
    @Binding var showTonicPicker: Bool
    
    var body: some View {
        HStack {
            HStack(spacing: 20) {
                HelpView(viewConductor: viewConductor)
                OctaveShiftPitchDirectionView(viewConductor: viewConductor, tonicConductor: tonicConductor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            TonicPickerSettingsView(tonicConductor: tonicConductor, showTonicPicker: $showTonicPicker)
            PitchDirectionPickerView(viewConductor: viewConductor, tonicConductor: tonicConductor)
        }
    }
}
