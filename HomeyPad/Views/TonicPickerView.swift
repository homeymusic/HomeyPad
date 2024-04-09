import SwiftUI

struct TonicPickerView: View {
    @StateObject var viewConductor: ViewConductor
    @State private var showSettings = false
    
    var body: some View {
        HStack {
            ForEach(0...12, id: \.self) { tonicClass in
                Button {
                } label: {
                    Color.pink
                        .aspectRatio(1.0, contentMode: .fit)
                }
            }
        }
    }
}
