import CoreGraphics
import SwiftUI

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

public enum IntegerNotation: Int8, CaseIterable, Identifiable {
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
    
    public var id: Int8 { self.rawValue }

}

enum PitchDirection: Int8, CaseIterable, Identifiable {
    case upward    = 1
    case ambiguous = 0
    case downward  = -1
    
    var id: Int8 { self.rawValue }
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
