import SwiftUI
import SwiftData
import HomeyMusicKit

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(AppContext.self) public var appContext
    @Environment(MusicalInstrumentCache.self) public var musicalInstrumentCache
    @Environment(TonalityCache.self) public var tonalityCache

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
                            .aspectRatio(tonalityInstrument.viewRatio, contentMode: .fit)

                        MusicalInstrumentView(musicalInstrument)
                            .ignoresSafeArea(edges: .horizontal)
                            .onAppear {
                                musicalInstrument.showModeOutlines = tonalityInstrument.showModePicker
                                musicalInstrumentCache.set([musicalInstrument])
                                musicalInstrumentCache.selectMusicalInstrument(musicalInstrument)
                                tonalityCache.set([tonalityInstrument.tonality])
                            }
                            .onChange(of: appContext.instrumentType) {
                                if musicalInstrument.latching {
                                    musicalInstrument.activateMIDINoteNumbers(midiNoteNumbers: appContext.latchedMIDINoteNumbers)
                                }
                                appContext.latchedMIDINoteNumbers = []
                                musicalInstrumentCache.set([musicalInstrument])
                                musicalInstrumentCache.selectMusicalInstrument(musicalInstrument)
                                tonalityCache.set([tonalityInstrument.tonality])
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
