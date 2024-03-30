import Keyboard
import SwiftUI
import Tonic

struct ContentView: View {
    @StateObject var viewConductor = ViewConductor()
    
    var body: some View {
        ZStack {
            Color.black
            VStack(spacing: 0) {
                HeaderView(viewConductor: viewConductor)
                KeyboardView(viewConductor: viewConductor)
                    .frame(maxHeight: 300)
                FooterView(viewConductor: viewConductor)
            }
        }
        .statusBarHidden(true)
        .ignoresSafeArea(edges:.horizontal)
        .background(.black)
    }
}
