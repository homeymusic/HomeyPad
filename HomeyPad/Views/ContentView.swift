import SwiftUI
import HomeyMusicKit

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(NotationalContext.self) public var notationalContext
    @Environment(InstrumentalContext.self) public var instrumentalContext

    var body: some View {
        let settingsHeight = 30.0
        let settingsBuffer = 5.0
        let homeIndicatorBuffer = 10.0
        
        GeometryReader { proxy in
            ZStack {
                ZStack() {
                    VStack {
                        HeaderView()
                        .frame(height: settingsHeight)
                        Spacer()
                    }
                    VStack(spacing: settingsBuffer) {
                        TonicModePickerView()
                        
                        InstrumentView(instrumentalContext.instrument)
                            .ignoresSafeArea(edges:.horizontal)
                    }
                    .frame(height: .infinity)
                    .padding(.top, settingsHeight + settingsBuffer)
                    .padding(.bottom, settingsHeight + settingsBuffer + homeIndicatorBuffer / 2.0)
                    VStack {
                        Spacer()
                        FooterView()
                        .frame(height: settingsHeight)
                    }
                    
                }
            }
            .statusBarHiddenCrossPlatform(true)
            .background(.black)
            .padding(.bottom, homeIndicatorBuffer)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            IntervalColorPalette.seedSystemIntervalPalettes(modelContext: modelContext, notationalContext: notationalContext)
            PitchColorPalette.seedSystemPitchPalettes(modelContext: modelContext)
            notationalContext.loadColorPaletteIDs(modelContext: modelContext)
        }
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
