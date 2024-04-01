import CoreGraphics

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
