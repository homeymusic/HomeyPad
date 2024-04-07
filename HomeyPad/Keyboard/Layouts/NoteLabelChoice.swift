public enum NoteLabelChoice: String, CaseIterable, Identifiable {
    case letter    = "letter"
    case fixedDo   = "fixed do"
    case month     = "month"
    case octave    = "octave"
    case midi      = "midi"
    case frequency = "frequency"

    public var id: String { self.rawValue }

    public var icon: String {
        switch self {
        case .letter:    return "c.square"
        case .fixedDo:   return "person.2.wave.2"
        case .month:     return "calendar"
        case .octave:    return "4.square"
        case .midi:      return "60.square"
        case .frequency: return "water.waves"
        }
    }
    
    public var label: String {
        switch self {
        case .midi: return self.rawValue.uppercased()
        default: return self.rawValue.capitalized
        }
    }
}
