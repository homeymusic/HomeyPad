import SwiftUI

struct HomePickerView: View {
    @StateObject var viewConductor: ViewConductor
    @State private var showSettings = false
    
    var body: some View {
        /// tonic selector toggle
        Toggle("", isOn: $viewConductor.showHomePicker).labelsHidden()
            .tint(Color(UIColor.darkGray))
            .padding(.leading, 10)
        Button(action: {
            self.showSettings.toggle()
        }) {
            ZStack {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(viewConductor.showHomePicker ? .white : Color(UIColor.darkGray))
                Image(systemName: "square").foregroundColor(.clear)
            }
        }
        .disabled(!viewConductor.showHomePicker)
        .popover(isPresented: $showSettings,
                 content: {
            /// labels for tonic selector
            HomePickerSettingsView(viewConductor: viewConductor)
            .presentationCompactAdaptation(.none)
        })
        .padding(.leading, 10)
    }
}
