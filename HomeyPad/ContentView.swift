import SwiftUI
import AVFoundation
import HomeyMusicKit

struct ContentView: View {
    let defaults = UserDefaults.standard
    
    let tonalContext: TonalContext
    let instrumentalContext: InstrumentalContext
    let notationalTonicContext: NotationalTonicContext
    
    init(tonalContext: TonalContext,
         instrumentalContext: InstrumentalContext,
         notationalTonicContext: NotationalTonicContext) {
        self.tonalContext = tonalContext
        self.instrumentalContext = instrumentalContext
        self.notationalTonicContext = notationalTonicContext
        
        // Set up for encoding and decoding the user default dictionaries
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
//        // Latching
//        defaults.register(defaults: [
//            "latching" : false
//        ])
//        let latching = defaults.bool(forKey: "latching")
//        
    }
    
    var body: some View {
        let settingsHeight = 30.0
        
        GeometryReader { proxy in
            ZStack {
                Color.black
                ZStack() {
                    // Header
                    VStack {
                        HeaderView()
                        .frame(height: settingsHeight)
                        Spacer()
                    }
                    // Tonic Picker & Keyboard
                    VStack {
                        // Tonic Picker
                        TonicAndModePickerView()
                        //                        if HomeyMusicKit.formFactor == .iPad && instrumentalContext.instrument is KeyboardInstrument {
                        //                            InstrumentView(
                        //                                conductor: viewConductor
                        //                            ) { pitch in
                        //                                PitchView(
                        //                                    pitch: pitch,
                        //                                    thisConductor: viewConductor,
                        //                                    tonicConductor: tonicConductor,
                        //                                    viewConductor: viewConductor,
                        //                                    modeConductor: modeConductor
                        //                                )
                        //                            }
                        //                            .aspectRatio(4.0, contentMode: .fit)
                        //                            .ignoresSafeArea(edges:.horizontal)
                        //                        }
                        
                        //                        if !HomeyMusicKit.formFactor == .iPad {
                        InstrumentView()
                        .ignoresSafeArea(edges:.horizontal)
                        //                          }
                    }
                    .frame(height: .infinity)
                    .padding([.top, .bottom], settingsHeight + 5.0)
                    // Footer
                    VStack {
                        Spacer()
                        FooterView()
                        .frame(height: settingsHeight)
                    }
                    
                }
            }
            .statusBarHidden(true)
            .background(.black)
            
        }
        .preferredColorScheme(.dark)
    }
}
