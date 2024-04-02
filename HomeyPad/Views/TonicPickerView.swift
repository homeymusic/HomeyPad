import SwiftUI

struct TonicPickerView: View {
    @StateObject var viewConductor: ViewConductor
    @State private var showSettings = false
    
    var body: some View {
        Toggle("", isOn: $viewConductor.showTonicPicker).labelsHidden()
            .tint(Color(UIColor.darkGray))
            .padding(.leading, 10)
        Button(action: {
            self.showSettings.toggle()
        }) {
            ZStack {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(viewConductor.showTonicPicker ? .white : Color(UIColor.darkGray))
                Image(systemName: "square").foregroundColor(.clear)
            }
        }
        .disabled(!viewConductor.showTonicPicker)
        .popover(isPresented: $showSettings,
                 content: {
            TonicPickerSettingsView(viewConductor: viewConductor)
        })
        .padding(.leading, 10)
    }
}
