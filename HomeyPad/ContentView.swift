import SwiftUI

struct ContentView: View {
    @StateObject var viewConductor = ViewConductor()
    
    var body: some View {
        let settingsHeight = 30.0
        ZStack {
            Color.black
            ZStack() {
                VStack {
                    HeaderView(viewConductor: viewConductor)
                        .frame(height: settingsHeight)
                    Spacer()
                }
                KeyboardView(viewConductor: viewConductor)
                    .frame(height: .infinity)
                    .padding([.top, .bottom], settingsHeight + 5.0)
                VStack {
                    Spacer()
                    FooterView(viewConductor: viewConductor)
                        .frame(height: settingsHeight)
                }

            }
        }
        .statusBarHidden(true)
        .ignoresSafeArea(edges:.horizontal)
        .background(.black)
    }
}
