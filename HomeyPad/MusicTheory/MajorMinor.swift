import CoreGraphics

enum MajorMinor: Int, CaseIterable, Identifiable, Comparable, Equatable {
    case minor   = 0
    case neutral = 1
    case major   = 2
    
    var id: Int { self.rawValue }

    var color: CGColor {
        switch self {
        case .minor:   return #colorLiteral(red: 0.5411764706, green: 0.7725490196, blue: 1, alpha: 1)
        case .neutral: return #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1)
        case .major:   return #colorLiteral(red: 1, green: 0.6901960784, blue: 0, alpha: 1)
        }
    }

    static func < (lhs: MajorMinor, rhs: MajorMinor) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
}
