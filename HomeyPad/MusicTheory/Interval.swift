import SwiftUI
import CoreGraphics

struct Interval {
    public var pitch: Pitch
    public var tonicPitch: Pitch
    public var semitones: Int8
    public var intervalClass: IntegerNotation
    public var octaveDistance: Int8
    
    public init(pitch: Pitch, tonicPitch: Pitch) {
        self.pitch = pitch
        self.tonicPitch = tonicPitch
        self.semitones = pitch.semitones(to: tonicPitch)
        self.intervalClass = IntegerNotation(rawValue: modulo(self.semitones, 12))!
        self.octaveDistance = Int8(self.semitones / 12)
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
        var pitchDirection: PitchDirection = .ambiguous
        if self.semitones < 0 {
            pitchDirection = .downward
        } else if self.semitones > 0 {
            pitchDirection = .upward
        }
        return pitchDirection
    }
    
    public var mainColor: CGColor {
        #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1)
    }

}

enum MajorMinor: String, CaseIterable, Identifiable {
    case minor = "minor"
    case neutral = "neutral"
    case major = "major"
    
    var id: String { self.rawValue }

    var color: CGColor {
        switch self {
        case .minor: return #colorLiteral(red: 0.5411764706, green: 0.7725490196, blue: 1, alpha: 1)
        case .neutral: return #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1)
        case .major: return #colorLiteral(red: 1, green: 0.6901960784, blue: 0, alpha: 1)
        }
    }
}

enum ConsonanceDissonance: Int, CaseIterable, Identifiable, Comparable {
    static func < (lhs: ConsonanceDissonance, rhs: ConsonanceDissonance) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case dissonant = 0
    case consonant = 1
    case perfect = 2
    case octave = 3
    case tonic = 4
    
    var id: Int { self.rawValue }
    
    var symbol: any Shape {
        switch self {
        case .tonic: return NitterHouseWithDoor()
        case .octave: return NitterHouse()
        case .perfect: return NitterTurret()
        case .consonant: return NitterDiamond()
        case .dissonant: return Circle()
        }
    }
    
    var symbolLength: CGFloat {
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
