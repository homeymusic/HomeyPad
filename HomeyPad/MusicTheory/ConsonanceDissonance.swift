import SwiftUI

enum ConsonanceDissonance: Int, CaseIterable, Identifiable, Comparable, Equatable {
    case tonic = 4
    case octave = 3
    case perfect = 2
    case consonant = 1
    case dissonant = 0
    
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
    
    var icon: String {
        switch self {
        case .tonic: return "house.fill"
        case .octave: return "house"
        case .perfect: return "triangle.fill"
        case .consonant: return "diamond.fill"
        case .dissonant: return "circle.fill"
        }
    }

    var label: String {
        switch self {
        case .tonic: return "tonic"
        case .octave: return "octave"
        case .perfect: return "perfect"
        case .consonant: return "consonant"
        case .dissonant: return "dissonant"
        }
    }
    
    var symbolLength: CGFloat {
        let coefficient = 0.0225
        let home        = coefficient * 16.0
        let tent        = coefficient * 14.0
        let diamond     = coefficient * 12.0
        let circle      = coefficient * 10.0
        switch self {
        case .tonic: return home
        case .octave: return home
        case .perfect: return tent
        case .consonant: return diamond
        case .dissonant: return circle
        }
    }
    
    var maxSymbolLength: CGFloat {
        let coefficient = 0.0225
        return coefficient * 16.0
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
                path.closeSubpath()
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
                path.closeSubpath()
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
                path.closeSubpath()
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
                path.closeSubpath()
            }
        }
    }
    
    static func < (lhs: ConsonanceDissonance, rhs: ConsonanceDissonance) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
}
