public enum NoteLabelChoice: String, CaseIterable, Identifiable {
    case letter      = "letter"
    case fixedDo     = "fixed do"
    case accidentals = "accidentals"
    case octave      = "octave"
    case midi        = "midi"
    case frequency   = "frequency"
    case mode        = "mode"
    case plot         = "plot"
    case month       = "month"

    public var id: String { self.rawValue }

    public var icon: String {
        switch self {
        case .letter:      return "c.square"
        case .accidentals: return "arrow.up.arrow.down.square"
        case .octave:      return "4.square"
        case .fixedDo:     return "person.2.wave.2"
        case .month:       return "calendar"
        case .mode:        return "building.columns"
        case .plot:        return "map"
        case .midi:        return "60.square"
        case .frequency:   return "water.waves"
        }
    }
    
    public var label: String {
        switch self {
        case .midi: return self.rawValue.uppercased()
        default: return self.rawValue.capitalized
        }
    }
}
