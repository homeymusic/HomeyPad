import SwiftUI

struct ContentView: View {
    @StateObject var viewConductor  = ViewConductor()
    @StateObject var tonicConductor = ViewConductor(layoutChoice: .tonic, latching: true)
    
    var body: some View {
        let settingsHeight = 30.0
        GeometryReader { proxy in
            ZStack {
                Color.black
                ZStack() {
                    VStack {
                        HeaderView(viewConductor: viewConductor, tonicConductor: tonicConductor)
                            .frame(height: settingsHeight)
                        Spacer()
                    }
                    VStack {
                        if tonicConductor.showTonicPicker {
                            Keyboard(viewConductor: tonicConductor) { pitch in
                                KeyboardKey(pitch: pitch,
                                            viewConductor: tonicConductor)
                            }
                                .transition(.scale)
                        }
                        Keyboard(viewConductor: viewConductor) { pitch in
                            KeyboardKey(pitch: pitch,
                                        viewConductor: viewConductor)
                        }
                            .ignoresSafeArea(edges:.horizontal)
                    }
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
            .background(.black)
        }
    }
}
