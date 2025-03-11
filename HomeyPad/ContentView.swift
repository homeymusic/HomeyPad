import SwiftUI
import AVFoundation
import HomeyMusicKit

struct ContentView: View {
    let defaults = UserDefaults.standard
    @StateObject private var tonicConductor: TonicConductor
    @StateObject private var modeConductor: ViewConductor
    @StateObject private var viewConductor: ViewConductor
    
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
        
        // Latching
        defaults.register(defaults: [
            "latching" : false
        ])
        let latching = defaults.bool(forKey: "latching")
        
        _tonicConductor = StateObject(wrappedValue: TonicConductor(
            tonalContext: tonalContext
        ))
        
        _modeConductor = StateObject(wrappedValue: ViewConductor(
            layoutChoice: .mode,
            sendTonicState: false,
            tonalContext: tonalContext
        ))
        
        _viewConductor = StateObject(wrappedValue: ViewConductor(
            layoutChoice: .diamanti,
            latching: latching,
            sendTonicState: false,
            tonalContext: tonalContext
        ))
        
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
                        TonicAndModePickerView(
                            tonicConductor: tonicConductor,
                            modeConductor: modeConductor
                        )
                        //                        if HomeyPad.formFactor == .iPad && instrumentalContext.instrument is KeyboardInstrument {
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
                        
                        //                        if !HomeyPad.formFactor == .iPad {
                        InstrumentView(
                            conductor: viewConductor
                        )
                        .ignoresSafeArea(edges:.horizontal)
                        //                          }
                    }
                    .frame(height: .infinity)
                    .padding([.top, .bottom], settingsHeight + 5.0)
                    // Footer
                    VStack {
                        Spacer()
                        FooterView(
                            viewConductor: viewConductor
                        )
                        .frame(height: settingsHeight)
                    }
                    
                }
            }
            .statusBarHidden(true)
            .background(.black)
            .environmentObject(tonicConductor)
            .environmentObject(modeConductor)
            .environmentObject(viewConductor)
            
        }
        .preferredColorScheme(.dark)
    }
}
