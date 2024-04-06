public enum NoteLabelChoice: String, CaseIterable, Identifiable {
    case letter    = "letter"
    case fixedDo   = "fixed do"
    case month     = "month"
    case midi      = "midi"
    case frequency = "frequency"

    public var id: String { self.rawValue }

    public var icon: String {
        switch self {
        case .letter:    return "c.square"
        case .fixedDo:   return "person.2.wave.2"
        case .midi:      return "48.square"
        case .frequency: return "water.waves"
        case .month:     return "calendar"
        }
    }
    
    public var label: String {
        switch self {
        case .midi: return self.rawValue.uppercased()
        default: return self.rawValue.capitalized
        }
    }
}
