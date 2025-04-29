import SwiftUI
import SwiftData
import AVFoundation
import HomeyMusicKit

@main
struct HomeyPad: App {
    
    @State private var appContext = AppContext()
    public static let pitches = Pitch.allPitches()
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
