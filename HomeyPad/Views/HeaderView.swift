import SwiftUI

struct HeaderView: View {
    @StateObject var viewConductor: ViewConductor
    @StateObject var tonicConductor: ViewConductor

    var body: some View {
        HStack {
            OctaveShiftView(viewConductor: viewConductor)
            TonicPickerSettingsView(tonicConductor: tonicConductor)
            HelpView()
        }
    }
}
