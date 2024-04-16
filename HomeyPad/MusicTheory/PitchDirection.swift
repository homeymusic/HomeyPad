
enum PitchDirection: Int, CaseIterable, Identifiable {
    case upward   = 1
    case both     = 0
    case downward = -1
    
    var id: Int { self.rawValue }
    
    public var icon: String {
        switch self {
        case .upward:   return "greaterthan.square"
        case .both:     return "equal.square"
        case .downward: return "lessthan.square"
        }
    }

    public var asciiSymbol: String {
        switch self {
        case .upward:   return ">"
        case .both:     return "="
        case .downward: return "<"
        }
    }
    
    public var majorMinor: MajorMinor {
        switch self {
        case .upward:   return .major
        case .both:     return .neutral
        case .downward: return .minor
        }
    }

    public var shortHand: String {
        switch self {
        case .upward:   return ""
        case .both:     return ""
        case .downward: return "<"
        }
    }

    public var label: String {
        switch self {
        case .upward:   return "upward"
        case .both:     return "upward or downward"
        case .downward: return "downward"
        }
    }
}
