import SwiftUI

struct ContentView: View {
    @State var showTonicPicker: Bool = false
    @StateObject var viewConductor  = ViewConductor()
    @StateObject var tonicConductor = ViewConductor(layoutChoice: .tonic, latching: true)

    @State var tonicMIDI: Int = 60
    
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
                            Keyboard(conductor: tonicConductor, tonicMIDI: $tonicMIDI) { pitch in
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
                            .transition(.scale)
                        }
                        Keyboard(conductor: viewConductor, tonicMIDI: $tonicMIDI) { pitch in
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
            .onAppear {
                tonicMIDI = tonicConductor.tonicMIDI
            }
            .onChange(of: tonicMIDI) {
                if tonicMIDI != tonicConductor.tonicMIDI {
                    if tonicMIDI == tonicConductor.tonicMIDI + 12 {
                        tonicConductor.pitchDirection = .downward
                        viewConductor.pitchDirection = .downward
                    } else if tonicMIDI == tonicConductor.tonicMIDI - 12 {
                        tonicConductor.pitchDirection = .upward
                        viewConductor.pitchDirection = .upward
                    }
                    tonicConductor.tonicMIDI = tonicMIDI
                    viewConductor.tonicMIDI = tonicMIDI
                    buzz()
                }
            }.onChange(of: tonicConductor.tonicMIDI) {
                tonicMIDI = tonicConductor.tonicMIDI
            }
        }
        .preferredColorScheme(.dark)
    }
}
