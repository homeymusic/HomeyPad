import SwiftUI
import AVFoundation

@main
struct HomeyPad: App {
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let err {
            print(err)
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
