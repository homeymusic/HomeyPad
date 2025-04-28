import SwiftUI
import SwiftData
import AVFoundation
import HomeyMusicKit

@main
struct HomeyPad: App {
    
    // Single-liner: create and setup in one go.
    @State private var appContext = AppContext()
    @State private var orchestrator = Orchestrator().setup()

    public static let synthConductor = SynthConductor()
    public static let midiConductor = {
        let mc = MIDIConductor(
            clientName:   "Homey Pad",
            model:        "Homey Pad iOS",
            manufacturer: "Homey Music"
        )
        mc.setup()
        return mc
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appContext)
                .environment(orchestrator.tonalContext)
                .environment(orchestrator.instrumentalContext)
        }
        .modelContainer(for: [
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
        ])
    }
}
