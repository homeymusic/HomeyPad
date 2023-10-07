import SwiftUI
import AVFoundation
import Tonic

enum FormFactor {
    case iPad
    case iPhone
}

func formFactor() -> FormFactor {
    return UIScreen.main.bounds.size.width > 1000 ? .iPad : .iPhone
}

func defaultKeysPerRow() -> Int {
    if  formFactor() == .iPad {
        return 25
    } else {
        return 17
    }
}

func maxKeysPerRow() -> Int {
    if  formFactor() == .iPad {
        return 37 + 24
    } else {
        return 37
    }
}

func minKeysPerRow() -> Int {
    return 13
}

enum Default {
    static let showRoll: Bool = false
    static let showSelector: Bool = false
    static let showClassicalSelector: Bool = true
    static let showIntegersSelector: Bool = false
    static let showMonthsSelector: Bool = false
    static let showPianoSelector: Bool = false
    static let showIntervals: Bool = false
    static let octaveCount: Int = 1
    static let keysPerRow: Int = defaultKeysPerRow()
    static let tonicPitchClass: Int = 0
    static let majorColor: Color = Color(red: 255 / 255, green: 176 / 255, blue: 0 / 255)
    static let minorColor: Color = Color(red: 138 / 255, green: 197 / 255, blue: 320 / 255)
    static let tritoneColor: Color = Color(red: 255 / 255, green: 85 / 255, blue: 0 / 255)
    static let homeComplementColor: Color = Color(red: 102 / 255, green: 68 / 255, blue: 51 / 255)
    static let homeColor: Color = Color(red: 243 / 255, green: 221 / 255, blue: 171 / 255)
    static let pianoGray: Color = Color(red: 96/255, green: 96/255, blue: 96/255)
    static let highlightGray: Color = Color(red: 45/255, green: 45/255, blue: 45/255)
    static let chromaticColor: Color = Color(red: 222/255, green: 187/255, blue: 147/255)
    static let initialC: Int = 60
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

func homeyForegroundColor(_ interval: Int, reverseHomeColor: Bool = true) -> Color {
    switch mod(interval, 12) {
    case 0:
        return reverseHomeColor ? Default.homeComplementColor : Default.homeColor
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
        return "Apr"
    case 1:
        return "May"
    case 2:
        return "Jun"
    case 3:
        return "Jul"
    case 4:
        return "Aug"
    case 5:
        return "Sep"
    case 6:
        return "Oct"
    case 7:
        return "Nov"
    case 8:
        return "Dec"
    case 9:
        return "Jan"
    case 10:
        return "Feb"
    case 11 :
        return "Mar"
    default: return ""
    }
    
}

func intervalLabel(_ col: Int) -> String {
    
    switch col {
    case -24:
        return "-P15"
    case -23:
        return "-M14"
    case -22:
        return "-m14"
    case -21:
        return "-M13"
    case -20:
        return "-m13"
    case -19:
        return "-P12"
    case -18:
        return "-tt"
    case -17:
        return "-P11"
    case -16:
        return "-M10"
    case -15:
        return "-m19"
    case -14:
        return "-M9"
    case -13:
        return "-m9"
    case -12:
        return "-P8"
    case -11:
        return "-M7"
    case -10:
        return "-m7"
    case -9:
        return "-M6"
    case -8:
        return "-m6"
    case -7:
        return "-P5"
    case -6:
        return "-tt"
    case -5:
        return "-P4"
    case -4:
        return "-M3"
    case -3:
        return "-m3"
    case -2:
        return "-M2"
    case -1:
        return "-m2"
    case 0:
        return "P1"
    case 1:
        return "m2"
    case 2:
        return "M2"
    case 3:
        return "m3"
    case 4:
        return "M3"
    case 5:
        return "P4"
    case 6:
        return "tt"
    case 7:
        return "P5"
    case 8:
        return "m6"
    case 9:
        return "M6"
    case 10:
        return "m7"
    case 11:
        return "M7"
    case 12:
        return "P8"
    case 13:
        return "m9"
    case 14:
        return "M9"
    case 15:
        return "m10"
    case 16:
        return "M10"
    case 17:
        return "P11"
    case 18:
        return "tt"
    case 19:
        return "P12"
    case 20:
        return "m13"
    case 21:
        return "M13"
    case 22:
        return "m14"
    case 23:
        return "M14"
    case 24:
        return "P15"
    case 25:
        return "m16"
    case 26:
        return "M16"
    case 27:
        return "m17"
    case 28:
        return "M17"
    case 29:
        return "P18"
    case 30:
        return "tt"
    case 31:
        return "P19"
    case 32:
        return "m20"
    case 33:
        return "M20"
    case 34:
        return "m21"
    case 35:
        return "M21"
    case 36:
        return "P22"
    default: return ""
    }
}

enum PlayerState {
    case playing
    case paused
    case stopped
}

struct NitterHouse: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: 0.4*rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: 0.4*rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
    }
}

@main
struct HomeyPad: App {
    init() {
#if os(iOS)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
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
