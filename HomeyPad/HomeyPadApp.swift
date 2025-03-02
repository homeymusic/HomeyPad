import SwiftUI
import AVFoundation
import HomeyMusicKit

@main
struct HomeyPad: App {
    
    init() {
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    enum FormFactor {
        case iPad
        case iPhone
    }

    static let formFactor: FormFactor = UIScreen.main.bounds.size.width > 1000 ? .iPad : .iPhone

}

