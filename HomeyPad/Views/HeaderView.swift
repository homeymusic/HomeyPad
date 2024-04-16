import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var tonicConductor: ViewConductor
    @Binding var showTonicPicker: Bool
    
    var body: some View {
        HStack {
            OctaveShiftPitchDirectionView(viewConductor: viewConductor, tonicConductor: tonicConductor)
            TonicPickerSettingsView(tonicConductor: tonicConductor, showTonicPicker: $showTonicPicker)
            HelpView(tonicConductor: tonicConductor)
        }
    }
}
