import SwiftUI
import SwiftData
import HomeyMusicKit

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(AppContext.self) public var appContext
    @Environment(InstrumentCache.self) public var instrumentCache

    private var musicalInstrument: MusicalInstrument {
        // force-cast because we know all of your concrete models
        modelContext.singletonInstrument(for: appContext.instrumentType)
    }
    
    private var tonalityInstrument: TonalityInstrument {
        // force-cast because we know all of your concrete models
        modelContext.tonalityInstrument()
    }
    
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
                        
                        TonalityInstrumentView(tonalityInstrument)

                        MusicalInstrumentView(musicalInstrument)
                            .ignoresSafeArea(edges: .horizontal)
                            .onAppear {
                                musicalInstrument.showModeOutlines = tonalityInstrument.showModePicker
                                instrumentCache.set([musicalInstrument])
                                instrumentCache.selectInstrument(musicalInstrument)
                            }
                            .onChange(of: appContext.instrumentType) {
                                if musicalInstrument.latching {
                                    musicalInstrument.activateMIDINoteNumbers(midiNoteNumbers: appContext.latchedMIDINoteNumbers)
                                }
                                appContext.latchedMIDINoteNumbers = []
                                instrumentCache.set([musicalInstrument])
                                instrumentCache.selectInstrument(musicalInstrument)
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
