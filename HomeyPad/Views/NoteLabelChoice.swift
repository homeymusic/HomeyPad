public enum NoteLabelChoice: String, CaseIterable, Identifiable, Codable {
    case letter      = "letter"
    case accidentals = "accidentals"
    case octave      = "octave"
    case fixedDo     = "fixed do"
    case month       = "month"
    case midi        = "midi"
    case wavelength  = "wavelength"
    case wavenumber  = "wavenumber"
    case period      = "period"
    case frequency   = "frequency"
    case cochlea     = "cochlea"
    case mode        = "mode"
    case plot        = "plot"

    public var id: String { self.rawValue }

    public var icon: String {
        switch self {
        case .letter:      return "c.square"
        case .fixedDo:     return "person.2.wave.2"
        case .accidentals: return "number.square"
        case .octave:      return "4.square"
        case .midi:        return "60.square"
        case .wavelength:  return "ruler"
        case .wavenumber:  return "spatial.frequency"
        case .period:      return "stopwatch"
        case .frequency:   return "temporal.frequency"
        case .cochlea:     return "fossil.shell"
        case .mode:        return "building.columns"
        case .plot:        return "map"
        case .month:       return "calendar"
        }
    }
    
    public var isCustomIcon: Bool {
        switch self {
        case .midi: return true
        case .wavenumber: return true
        case .frequency: return true
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
