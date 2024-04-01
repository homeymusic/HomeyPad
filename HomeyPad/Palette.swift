import CoreGraphics
import SwiftUI
import Tonic

enum Palette: String, CaseIterable, Identifiable {
    case subtle = "subtle"
    case loud = "loud"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .subtle: return "paintpalette"
        case .loud:   return "paintpalette.fill"
        }
    }
    
    public static var majorMinor: [CGColor] {
        [#colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1), #colorLiteral(red: 0.5411764706, green: 0.7725490196, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.6901960784, blue: 0, alpha: 1), #colorLiteral(red: 0.5411764706, green: 0.7725490196, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.6901960784, blue: 0, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1), #colorLiteral(red: 0.5411764706, green: 0.7725490196, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.6901960784, blue: 0, alpha: 1), #colorLiteral(red: 0.5411764706, green: 0.7725490196, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.6901960784, blue: 0, alpha: 1)]
    }
    
    public static var brown: CGColor {
        #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1)
    }
    
    public static var cream: CGColor {
        #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1)
    }
    
    func keyColor(pitch: Pitch, tonicPitch: Pitch, activated: Bool, highlightDiatonic: Bool) -> CGColor {
        let interval = PitchInterval(pitch: pitch, tonicPitch: tonicPitch)
        switch self {
        case .subtle: 
            return activated ? : Palette.brown
        case .loud:
            return Palette.majorMinor
        }
    }
    
}

enum MajorMinor: String, CaseIterable, Identifiable {
    case minor = "minor"
    case major = "major"
    case neutral = "neutral"
    
    var id: String { self.rawValue }

}

enum ConsonanceDissonance: String, CaseIterable, Identifiable {
    case tonic = "tonic"
    case octave = "octave"
    case perfect = "perfect"
    case consonant = "consonant"
    case dissonant = "dissonant"

    var id: String { self.rawValue }

    var symbol: any Shape {
        switch self {
        case .tonic: return NitterHouseWithDoor()
        case .octave: return NitterHouse()
        case .perfect: return NitterTurret()
        case .consonant: return NitterDiamond()
        case .dissonant: return Circle()
        }
    }
    
    var symbolSize: CGFloat {
        let coefficient = 0.0225
        let home        = coefficient * 16
        let tent        = coefficient * 14
        let diamond     = coefficient * 12
        let circle      = coefficient * 10
        switch self {
        case .tonic: return home
        case .octave: return home
        case .perfect: return tent
        case .consonant: return diamond
        case .dissonant: return circle
        }
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

    struct NitterHouseWithDoor: Shape {
        func path(in rect: CGRect) -> Path {
            let doorWidth = 0.125
            return Path { path in
                path.move(to: CGPoint(x: rect.midX - doorWidth * rect.maxX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.minX, y: 0.4*rect.maxY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: 0.4*rect.maxY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.midX + doorWidth * rect.maxX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.midX + doorWidth * rect.maxX, y: 0.65*rect.maxY))
                path.addLine(to: CGPoint(x: rect.midX - doorWidth * rect.maxX, y: 0.65*rect.maxY))
                path.addLine(to: CGPoint(x: rect.midX - doorWidth * rect.maxX, y: rect.maxY))
            }
        }
    }

    struct NitterTurret: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.minY)) // the tent peak
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            }
        }
    }

    struct NitterDiamond: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            }
        }
    }

}

enum IntervalClass: Int8, CaseIterable, Identifiable {
    case zero   = 0
    case one    = 1
    case two    = 2
    case three  = 3
    case four   = 4
    case five   = 5
    case six    = 6
    case seven  = 7
    case eight  = 8
    case nine   = 9
    case ten    = 10
    case eleven = 11
    
    var id: Int8 { self.rawValue }

}

enum PitchDirection: Int8, CaseIterable, Identifiable {
    case upward    = 1
    case ambiguous = 0
    case downward  = -1
    
    var id: Int8 { self.rawValue }
}

struct PitchInterval {
    public var pitch: Pitch
    public var tonicPitch: Pitch
    public var semitoneDistance: Int8
    public var intervalClass: IntervalClass
    public var octaveDistance: Int8
    
    public init(pitch: Pitch, tonicPitch: Pitch) {
        self.pitch = pitch
        self.tonicPitch = tonicPitch
        self.semitoneDistance = pitch.midiNoteNumber - tonicPitch.midiNoteNumber
        self.intervalClass = IntervalClass(rawValue: modulo(self.semitoneDistance, 12))!
        self.octaveDistance = Int8(self.semitoneDistance / 12)
    }
    
    public var majorMinor: MajorMinor {
        switch intervalClass {
        case .one, .three, .eight, .ten: return .minor
        case .zero, .five, .six, .seven: return .neutral
        case .two, .four, .nine, .eleven: return .major
        }
    }
    
    public var consonanceDissonance: ConsonanceDissonance {
        if pitch == tonicPitch {
            return .tonic
        } else {
            switch intervalClass {
            case .zero: return .octave
            case .five, .seven: return .perfect
            case .three, .four, .eight, .nine: return .consonant
            case .one, .two, .six, .ten, .eleven: return .dissonant
            }
        }
    }
    
    public var pitchDirection: PitchDirection {
        if self.semitoneDistance < 0 {
            return .downward
        } else if self.semitoneDistance == 0 {
            return .ambiguous
        } else if self.semitoneDistance > 0 {
            return .upward
        }
    }
    
}

func modulo(_ a: Int8, _ n: Int8) -> Int8 {
    precondition(n > 0, "modulus must be positive")
    let r = a % n
    return r >= 0 ? r : r + n
}

extension Color {
    func adjust(hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, opacity: CGFloat = 1) -> Color {
        let color = UIColor(self)
        var currentHue: CGFloat = 0
        var currentSaturation: CGFloat = 0
        var currentBrigthness: CGFloat = 0
        var currentOpacity: CGFloat = 0
        
        if color.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentOpacity) {
            return Color(hue: currentHue + hue, saturation: currentSaturation + saturation, brightness: currentBrigthness + brightness, opacity: currentOpacity + opacity)
        }
        return self
    }
}
