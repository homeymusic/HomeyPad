import SwiftUI
import SwiftData
import AVFoundation
import HomeyMusicKit

@main
struct HomeyPad: App {
    @State private var appContext: AppContext
    @State private var synthConductor: SynthConductor
    @State private var musicalInstrumentCache: MusicalInstrumentCache
    @State private var midiConductor: MIDIConductor
    
    init() {
        let appContext      = AppContext()
        let synthConductor  = SynthConductor()
        let musicalInstrumentCache = MusicalInstrumentCache()
        let midiConductor   = MIDIConductor(
            clientName:      "Homey Pad",
            model:           "Homey Pad iOS",
            manufacturer:    "Homey Music",
            musicalInstrumentCache: musicalInstrumentCache
        )
        midiConductor.setup()
        
        _appContext      = State(initialValue: appContext)
        _synthConductor  = State(initialValue: synthConductor)
        _musicalInstrumentCache = State(initialValue: musicalInstrumentCache)
        _midiConductor   = State(initialValue: midiConductor)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appContext)
                .environment(musicalInstrumentCache)
                .environment(synthConductor)
                .environment(midiConductor)
        }
        .modelContainer(
            for: [
                IntervalColorPalette.self,
                PitchColorPalette.self,
                Diamanti.self,
                Linear.self,
                Piano.self,
                Tonnetz.self,
                Banjo.self,
                Bass.self,
                Cello.self,
                Guitar.self,
                Violin.self,
                TonalityInstrument.self,
                Tonality.self
            ]
        )
    }
}
