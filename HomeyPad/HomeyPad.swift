import SwiftUI
import AVFoundation
import Tonic

enum Default {
    static let showClassicalSelector: Bool = false
    static let showMonthsSelector: Bool = false
    static let showPianoSelector: Bool = false
    static let showIntervals: Bool = false
    static let octaveCount: Int = 1
    static let keysPerRow: Int = 13
    static let tonicPitchClass: Int = 0
    static let majorColor: Color = Color(red: 255 / 255, green: 176 / 255, blue: 0 / 255)
    static let minorColor: Color = Color(red: 138 / 255, green: 197 / 255, blue: 320 / 255)
    static let tritoneColor: Color = Color(red: 255 / 255, green: 85 / 255, blue: 0 / 255)
    static let homeComplementColor: Color = Color(red: 102 / 255, green: 68 / 255, blue: 51 / 255)
    static let homeColor: Color = Color(red: 243 / 255, green: 221 / 255, blue: 171 / 255)
    static let pianoGray: Color = Color(red: 96/255, green: 96/255, blue: 96/255)
}

func mod(_ a: Int, _ n: Int) -> Int {
    precondition(n > 0, "modulus must be positive")
    let r = a % n
    return r >= 0 ? r : r + n
}

func homeyBackgroundColor(_ interval: Int) -> Color {
    if (mod(interval, 12) == 0) {
        return Default.homeColor
    } else {
        return Default.homeComplementColor
    }
}

func homeyForegroundColor(_ interval: Int) -> Color {
    switch mod(interval, 12) {
    case 0:
        return Default.homeComplementColor
    case 5, 7:
        return Default.homeColor
    case 1, 3, 8, 10:
        return Default.minorColor
    case 2, 4, 9, 11:
        return Default.majorColor
    case 6:
        return Default.tritoneColor
    default:
        return Default.homeColor
    }
}

func pianoForegroundColor(_ pitchClass: Int) -> Color {
    switch mod(pitchClass, 12) {
    case 1, 3, 6, 8, 10:
        return .white
    default:
        return Default.pianoGray
    }
}

func pianoBackgroundColor(_ pitchClass: Int) -> Color {
    switch mod(pitchClass, 12) {
    case 1, 3, 6, 8, 10:
        return Default.pianoGray
    default:
        return .white
    }
}

func classicalLabel(_ pitchClass: Int) -> String {
    switch mod(pitchClass, 12) {
    case 0:
        return NoteClass.C.description
    case 1:
        return "\(NoteClass.Cs.description) \(NoteClass.Db.description)"
    case 2:
        return NoteClass.D.description
    case 3:
        return "\(NoteClass.Ds.description) \(NoteClass.Eb.description)"
    case 4:
        return NoteClass.E.description
    case 5:
        return NoteClass.F.description
    case 6:
        return "\(NoteClass.Fs.description) \(NoteClass.Gb.description)"
    case 7:
        return NoteClass.G.description
    case 8:
        return "\(NoteClass.Gs.description) \(NoteClass.Ab.description)"
    case 9:
        return NoteClass.A.description
    case 10:
        return "\(NoteClass.As.description) \(NoteClass.Bb.description)"
    case 11:
        return NoteClass.B.description
    default: return NoteClass.C.description
    }

}

func monthLabel(_ pitchClass: Int) -> String {
    switch mod(pitchClass, 12) {
    case 0:
        return "Aug"
    case 1:
        return "Sep"
    case 2:
        return "Oct"
    case 3:
        return "Nov"
    case 4:
        return "Dec"
    case 5:
        return "Jan"
    case 6:
        return "Feb"
    case 7:
        return "Mar"
    case 8:
        return "Apr"
    case 9:
        return "May"
    case 10:
        return "Jun"
    case 11:
        return "Jul"
    default: return ""
    }

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
