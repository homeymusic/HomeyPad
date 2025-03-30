import SwiftUI
import AVFoundation
import HomeyMusicKit

@main
struct HomeyPad: App {
    
    @State private var orchestrator: Orchestrator
    
    init() {
        self.orchestrator = Orchestrator()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environment(orchestrator.tonalContext)
            .environment(orchestrator.instrumentalContext)
            .environment(orchestrator.notationalTonicContext)
            .environment(orchestrator.notationalContext)
        }
    }
    
}
