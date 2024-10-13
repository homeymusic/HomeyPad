public enum IntervalLabelChoice: String, CaseIterable, Identifiable, Codable {
    // Keep symbol as top choice
    case symbol          = "Symbol"
    // Keep symbol as top choice
    case movableDo       = "Movable Do"
    case interval        = "Interval"
    case roman           = "Roman"
    case degree          = "Degree"
    case integer         = "Integer"
    case wavelengthRatio = "Wavelength Ratios"
    case wavenumberRatio = "Wavenumber Ratios"
    case periodRatio     = "Period Ratios"
    case frequencyRatio  = "Frequency Ratios"

    public var id: String { self.rawValue }

    public var icon: String {
        switch self {
        case .symbol:          return "nitterhouse.fill"
        case .interval:        return "p1.button.horizontal"
        case .movableDo:       return "person.wave.2"
        case .roman:           return "i.square"
        case .degree:          return "control"
        case .integer:         return "0.square"
        case .wavelengthRatio: return "ruler"
        case .wavenumberRatio: return "spatial.frequency"
        case .periodRatio:     return "stopwatch"
        case .frequencyRatio:  return "temporal.frequency"
        }
    }

    public var isCustomIcon: Bool {
        switch self {
        case .symbol: return true
        case .wavenumberRatio: return true
        case .frequencyRatio: return true
        default:    return false
        }
    }

    public var label: String {
        return self.rawValue
    }
}
