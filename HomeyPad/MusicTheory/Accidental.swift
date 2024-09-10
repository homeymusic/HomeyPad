enum Accidental: Int, CaseIterable, Identifiable {
    case sharp   = 1
    case flat    = -1

    var id: Int { self.rawValue }
    
    public var icon: String {
        switch self {
        case .sharp:   return "greaterthan.square"
        case .flat:    return "equal.square"
        }
    }

    public var asciiSymbol: String {
        switch self {
        case .sharp: return "♯"
        case .flat:  return "♭"
        }
    }
    
    public var majorMinor: MajorMinor {
        switch self {
        case .sharp:   return .major
        case .flat:     return .minor
        }
    }

    public var shortHand: String {
        return asciiSymbol
    }

    public var label: String {
        return asciiSymbol
    }
}
