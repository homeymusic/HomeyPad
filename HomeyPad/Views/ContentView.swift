import SwiftUI
import HomeyMusicKit

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(AppContext.self) public var appContext

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
                        let tonicPicker = modelContext.singletonInstrument(for: InstrumentChoice.tonicPicker)
                        TonicModePickerView(tonicPicker)
                        
                        let instrument = modelContext.singletonInstrument(for: appContext.instrumentChoice)
                        InstrumentView(instrument)
                            .ignoresSafeArea(edges: .horizontal)
                            .onAppear {
                                instrument.showModeOutlines = appContext.showModePicker
                            }
                            .onChange(of: appContext.instrumentChoice) {
                                if instrument.latching {
                                    instrument.activateMIDINoteNumbers(midiNoteNumbers: appContext.latchedMIDINoteNumbers)
                                }
                                appContext.latchedMIDINoteNumbers = []
                            }
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
