enum ChordShape: String, CaseIterable, Identifiable, Comparable, Equatable {
    case positive = "major"
    case negative = "minor"
    case positiveNegative = "major or minor"
    case positiveInversion = "major inverted"
    case negativeInversion = "minor inverted"
    
    var id: String { self.rawValue }

    static func < (lhs: ChordShape, rhs: ChordShape) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    public var icon: String {
        switch self {
        case .positive:          return "plus.circle.fill"
        case .positiveInversion: return "xmark.circle.fill"
        case .negative:          return "minus.circle.fill"
        case .negativeInversion: return "i.circle.fill"
        case .positiveNegative:  return "plusminus.circle.fill"
        }
    }

    public var asciiSymbol: String {
        switch self {
        case .positive:          return "+"
        case .positiveInversion: return "x"
        case .negative:          return "-"
        case .negativeInversion: return "|"
        case .positiveNegative:  return "+/-"
        }
    }
    
    public var majorMinor: MajorMinor {
        switch self {
        case .positive:          return .major
        case .positiveInversion: return .major
        case .negative:          return .minor
        case .negativeInversion: return .minor
        case .positiveNegative:  return .neutral
        }
    }
}
