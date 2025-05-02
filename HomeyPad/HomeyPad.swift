import SwiftUI
import SwiftData
import AVFoundation
import HomeyMusicKit

@main
struct HomeyPad: App {
    // — all your singletons moved into @State
    @State private var appContext: AppContext
    @State private var synthConductor: SynthConductor
    @State private var instrumentCache: InstrumentCache
    @State private var midiConductor: MIDIConductor

    /// you can still keep this static array of all pitches
    public static let pitches = Pitch.allPitches()

    init() {
        // build each one with verbose camelCase names
        let appContext      = AppContext()
        let synthConductor  = SynthConductor()
        let instrumentCache = InstrumentCache()
        let midiConductor   = MIDIConductor(
            clientName:      "Homey Pad",
            model:           "Homey Pad iOS",
            manufacturer:    "Homey Music",
            instrumentCache: instrumentCache
        )
        midiConductor.setup()

        // wire them into @State
        _appContext      = State(initialValue: appContext)
        _synthConductor  = State(initialValue: synthConductor)
        _instrumentCache = State(initialValue: instrumentCache)
        _midiConductor   = State(initialValue: midiConductor)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appContext)
                .environment(instrumentCache)
                .environment(synthConductor)
                .environment(midiConductor)
        }
        .modelContainer(
            for: [
                Diamanti.self,
                Linear.self,
                Piano.self,
                Tonnetz.self,
                Banjo.self,
                Bass.self,
                Cello.self,
                Guitar.self,
                Violin.self,
                ModePicker.self,
                TonicPicker.self,
                IntervalColorPalette.self,
                PitchColorPalette.self
            ]
        )
    }
}
