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
                                    .fill(Color(tonicConductor.backgroundColor))
                            }                                
                            .transition(.scale(.leastNonzeroMagnitude, anchor: .top))
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
                        HeaderView(viewConductor: viewConductor, tonicConductor: tonicConductor, showTonicPicker: $showTonicPicker)
                            .frame(height: settingsHeight)
                        Spacer()
                    }
                    VStack {
                        Spacer()
                        FooterView(viewConductor: viewConductor)
                            .frame(height: settingsHeight)
                    }
                    
                }
            }
            .statusBarHidden(true)
            .background(.black)
            .onChange(of: tonicConductor.tonicMIDI) {
                viewConductor.tonicMIDI = tonicConductor.tonicMIDI
                tonicConductor.externallyActivatedPitches.removeAll()
            }
            .onChange(of: tonicConductor.pitchDirection) {
                viewConductor.pitchDirection = tonicConductor.pitchDirection
            }
        }
        .preferredColorScheme(.dark)
    }
}
