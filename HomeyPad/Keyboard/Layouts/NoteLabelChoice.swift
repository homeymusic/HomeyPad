public enum NoteLabelChoice: String, CaseIterable, Identifiable, Codable {
    case letter      = "letter"
    case fixedDo     = "fixed do"
    case accidentals = "accidentals"
    case octave      = "octave"
    case midi        = "midi"
    case frequency   = "frequency"
    case wavelength  = "wavelength"
    case cochlea     = "cochlea"
    case period      = "period"
    case mode        = "mode"
    case plot        = "plot"
    case month       = "month"

    public var id: String { self.rawValue }

    public var icon: String {
        switch self {
        case .letter:      return "c.square"
        case .fixedDo:     return "person.2.wave.2"
        case .accidentals: return "arrow.up.arrow.down.square"
        case .octave:      return "4.square"
        case .midi:        return "60.square"
        case .frequency:   return "waveform.path.badge.plus"
        case .period:      return "stopwatch"
        case .wavelength:  return "ruler"
        case .cochlea:     return "fossil.shell"
        case .mode:        return "building.columns"
        case .plot:        return "map"
        case .month:       return "calendar"
        }
    }
    
    public var isCustomIcon: Bool {
        switch self {
        case .midi: return true
        default:    return false
        }
    }
    
    public var label: String {
        switch self {
        case .midi: return self.rawValue.uppercased()
        default: return self.rawValue.capitalized
        }
    }
}
