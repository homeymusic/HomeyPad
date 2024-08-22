import CoreGraphics

enum MajorMinor: Int, CaseIterable, Identifiable, Comparable, Equatable {
    case major   =  1
    case neutral =  0
    case minor   = -1
    
    var id: Int { self.rawValue }

    var label: String {
        switch self {
        case .major:   return "major"
        case .neutral: return "neutral"
        case .minor:   return "minor"
        }
    }
    
    var color: CGColor {
        switch self {
        case .minor:   return #colorLiteral(red: 0.3647058824, green: 0.6784313725, blue: 0.9254901961, alpha: 1)
        case .neutral: return #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1)
        case .major:   return #colorLiteral(red: 1, green: 0.6745098039, blue: 0.2, alpha: 1)
        }
    }

    var shortHand: String {
        switch self {
        case .minor:   return "m"
        case .major:   return "M"
        case .neutral: return "P"
        }
    }

    static let altNeutralColor: CGColor =  #colorLiteral(red: 1, green: 0.333333, blue: 0, alpha: 1)
    
    static func < (lhs: MajorMinor, rhs: MajorMinor) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
}
