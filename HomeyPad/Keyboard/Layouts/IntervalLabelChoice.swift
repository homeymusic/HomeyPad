public enum IntervalLabelChoice: String, CaseIterable, Identifiable, Codable {
    case symbol     = "symbol"
    case interval   = "interval"
    case movableDo  = "movable do"
    case roman      = "roman"
    case degree     = "degree"
    case integer    = "integer"

    public var id: String { self.rawValue }

    public var icon: String {
        switch self {
        case .symbol:     return "diamond"
        case .interval:   return "p1.button.horizontal"
        case .movableDo:  return "person.wave.2"
        case .roman:      return "i.square"
        case .degree:     return "control"
        case .integer:    return "0.square"
        }
    }
    
    public var label: String {
        return self.rawValue.capitalized
    }
}
