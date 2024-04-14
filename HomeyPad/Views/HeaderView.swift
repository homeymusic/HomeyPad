import SwiftUI

struct HeaderView: View {
    @StateObject var viewConductor: ViewConductor
    @StateObject var tonicConductor: ViewConductor
    @Binding var showTonicPicker: Bool

    var body: some View {
        HStack {
            OctaveShiftView(viewConductor: viewConductor, tonicConductor: tonicConductor)
            TonicPickerSettingsView(tonicConductor: tonicConductor, showTonicPicker: $showTonicPicker)
            HelpView(tonicConductor: tonicConductor)
        }
    }
}
