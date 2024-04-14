enum ChordShape: String, CaseIterable, Identifiable, Comparable, Equatable {
    case positive = "major"
    case positiveInversion = "major inverted"
    case negative = "minor"
    case negativeInversion = "minor inverted"
    case positiveNegative = "major or minor"
    case diminished = "diminished"
    
    var id: String { self.rawValue }

    static func < (lhs: ChordShape, rhs: ChordShape) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    public var icon: String {
        switch self {
        case .positive:          return "plus.square.fill"
        case .positiveInversion: return "multiply.square.fill"
        case .negative:          return "minus.square.fill"
        case .negativeInversion: return "i.square.fill"
        case .positiveNegative:  return "plusminus"   // make a custom square version
        case .diminished:        return "star.square" // make a custom asterisk version
        }
    }

    public var asciiSymbol: String {
        switch self {
        case .positive:          return "+"
        case .positiveInversion: return "x"
        case .negative:          return "-"
        case .negativeInversion: return "|"
        case .positiveNegative:  return "+/-"
        case .diminished:        return "*"
        }
    }
    
    public var majorMinor: MajorMinor {
        switch self {
        case .positive:          return .major
        case .positiveInversion: return .major
        case .negative:          return .minor
        case .negativeInversion: return .minor
        case .positiveNegative:  return .neutral
        case .diminished:        return .neutral
        }
    }
}
