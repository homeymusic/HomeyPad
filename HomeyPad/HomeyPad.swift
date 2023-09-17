import SwiftUI
import AVFoundation

enum Default {
    static let showClassicalSelector: Bool = false
    static let showHomeySelector: Bool = false
    static let showPianoSelector: Bool = false
    static let showIntervals: Bool = false
    static let octaveCount: Int = 3
    static let keysPerRow: Int = 17
    static let tonicPitchClass: Int = 0
    static let majorColor: Color = Color(red: 255 / 255, green: 176 / 255, blue: 0 / 255)
    static let minorColor: Color = Color(red: 138 / 255, green: 197 / 255, blue: 320 / 255)
    static let tritoneColor: Color = Color(red: 255 / 255, green: 85 / 255, blue: 0 / 255)
}

@main
struct HomeyPad: App {
    init() {
#if os(iOS)
        do {
//            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(0.01)
            try AVAudioSession.sharedInstance().setCategory(.playback,
                                                            options: [.mixWithOthers, .allowBluetooth, .allowBluetoothA2DP])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let err {
            print(err)
        }
#endif
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
