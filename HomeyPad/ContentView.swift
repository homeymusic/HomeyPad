import SwiftUI

struct ContentView: View {
    @State var showTonicPicker: Bool = false
    @StateObject var viewConductor  = ViewConductor()
    @StateObject var tonicConductor = ViewConductor(layoutChoice: .tonic, latching: true)

    var body: some View {
        let settingsHeight = 30.0
        GeometryReader { proxy in
            ZStack {
                Color.black
                ZStack() {
                    VStack {
                        HeaderView(viewConductor: viewConductor, tonicConductor: tonicConductor, showTonicPicker: $showTonicPicker)
                            .frame(height: settingsHeight)
                        Spacer()
                    }
                    VStack {
                        if showTonicPicker {
                            Keyboard(conductor: tonicConductor) { pitch in
                                KeyboardKey(pitch: pitch,
                                            conductor: tonicConductor)
                                .aspectRatio(1.0, contentMode: .fit)
                            }
                            .aspectRatio(13.0, contentMode: .fit)
                            .padding(7.0)
                            .background {
                                RoundedRectangle(cornerRadius: 7.0)
                                    .fill(Color(UIColor.systemGray6))
                            }                                
                            .transition(.scale)
                        }
                        Keyboard(conductor: viewConductor) { pitch in
                            KeyboardKey(pitch: pitch,
                                        conductor: viewConductor)
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
