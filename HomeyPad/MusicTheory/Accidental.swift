enum Accidental: Int, CaseIterable, Identifiable {
    case flat    = -1
    case sharp   = 1

    var id: Int { self.rawValue }
    
    public var icon: String {
        switch self {
        case .flat:  return "♭"
        case .sharp: return "♯"
        }
    }

    public var asciiSymbol: String {
        switch self {
        case .flat:  return "♭"
        case .sharp: return "♯"
        }
    }
    
    public var majorMinor: MajorMinor {
        switch self {
        case .flat:     return .minor
        case .sharp:   return .major
        }
    }

    public var shortHand: String {
        return asciiSymbol
    }

    public var label: String {
        return asciiSymbol
    }
    
    static let defaultAccidental: Accidental = .sharp
}
