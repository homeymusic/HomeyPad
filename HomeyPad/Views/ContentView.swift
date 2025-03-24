import SwiftUI
import AVFoundation
import HomeyMusicKit

struct ContentView: View {
    let defaults = UserDefaults.standard
    
    let tonalContext: TonalContext
    let instrumentalContext: InstrumentalContext
    let notationalTonicContext: NotationalTonicContext
    
    public init(tonalContext: TonalContext,
         instrumentalContext: InstrumentalContext,
         notationalTonicContext: NotationalTonicContext) {
        self.tonalContext = tonalContext
        self.instrumentalContext = instrumentalContext
        self.notationalTonicContext = notationalTonicContext
        
    }
    
    var body: some View {
        let settingsHeight = 30.0
        
        GeometryReader { proxy in
            ZStack {
                Color(HomeyMusicKit.backgroundColor)
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
                        
                        InstrumentView()
                            .ignoresSafeArea(edges:.horizontal)
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
            .statusBarHiddenCrossPlatform(true)
            .background(Color(HomeyMusicKit.backgroundColor))
            
        }
        .preferredColorScheme(.dark)
    }
}

extension View {
    @ViewBuilder
    func statusBarHiddenCrossPlatform(_ hidden: Bool) -> some View {
        #if os(iOS)
        self.statusBarHidden(hidden)
        #else
        self
        #endif
    }
}
