import SwiftUI

struct HeaderView: View {
    @StateObject var viewConductor: ViewConductor
    
    var body: some View {
        HStack {
            OctaveShiftView(viewConductor: viewConductor)
            TonicPickerSettingsView(viewConductor: viewConductor)
            HelpView()
        }
    }
}
