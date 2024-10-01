public enum IntervalLabelChoice: String, CaseIterable, Identifiable, Codable {
    // Keep symbol as top choice
    case symbol      = "Symbol"
    // Keep symbol as top choice
    case movableDo   = "Movable Do"
    case interval    = "Interval"
    case roman       = "Roman"
    case degree      = "Degree"
    case integer     = "Integer"
    case freqRatio   = "Frequency Ratios"
    case periodRatio = "Period Ratios"
    case waveRatio   = "Wavelength Ratios"

    public var id: String { self.rawValue }

    public var icon: String {
        switch self {
        case .symbol:      return "house.fill"
        case .interval:    return "p1.button.horizontal"
        case .movableDo:   return "person.wave.2"
        case .roman:       return "i.square"
        case .degree:      return "control"
        case .integer:     return "0.square"
        case .freqRatio:   return "waveform.path.badge.plus"
        case .periodRatio: return "stopwatch"
        case .waveRatio:   return "ruler"
        }
    }
    
    public var label: String {
        return self.rawValue
    }
}
