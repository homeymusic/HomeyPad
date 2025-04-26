import SwiftUI
import SwiftData
import AVFoundation
import HomeyMusicKit

@main
struct HomeyPad: App {
    
    // Single-liner: create and setup in one go.
    @State private var orchestrator = Orchestrator().setup()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(orchestrator.tonalContext)
                .environment(orchestrator.instrumentalContext)
                .environment(orchestrator.notationalTonicContext)
                .environment(orchestrator.notationalContext)
        }
        .modelContainer(for: [
            Diamanti.self,
            Linear.self,
            Piano.self,
            Tonnetz.self,
            ModePicker.self,
            TonicPicker.self,
            Banjo.self,
            Bass.self,
            Cello.self,
            Guitar.self,
            Violin.self,
            IntervalColorPalette.self,
            PitchColorPalette.self
        ])
    }
}
