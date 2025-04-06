import SwiftUI
import HomeyMusicKit

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        let settingsHeight = 30.0
        
        GeometryReader { proxy in
            ZStack {
                ZStack() {
                    VStack {
                        HeaderView()
                        .frame(height: settingsHeight)
                        Spacer()
                    }
                    VStack(spacing: 5) {
                        TonicAndModePickerView()
                        
                        InstrumentView()
                            .ignoresSafeArea(edges:.horizontal)
                    }
                    .frame(height: .infinity)
                    .padding([.top, .bottom], settingsHeight + 5)
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
        .onAppear {
            ColorPalette.seedSystemData(modelContext: modelContext)
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
