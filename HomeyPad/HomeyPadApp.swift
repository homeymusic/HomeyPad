import SwiftUI
import SwiftData
import AVFoundation
import HomeyMusicKit

@main
struct HomeyPad: App {
    
    // Single-liner: create and setup in one go.
    @State private var orchestrator = Orchestrator().setup()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(orchestrator.tonalContext)
                .environment(orchestrator.instrumentalContext)
                .environment(orchestrator.notationalTonicContext)
                .environment(orchestrator.notationalContext)
        }
        .modelContainer(for: ColorPalette.self)
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active:
                orchestrator.synthConductor.reloadAudio()
            default:
                break
            }
        }
    }
}
