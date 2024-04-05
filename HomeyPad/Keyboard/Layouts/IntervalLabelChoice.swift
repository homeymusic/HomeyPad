public enum IntervalLabelChoice: String, CaseIterable, Identifiable {
    case interval = "interval"
    case roman    = "roman"
    case degree   = "degree"
    case integer  = "integer"
    case symbol   = "symbol"

    public var id: String { self.rawValue }

    public var icon: String {
        switch self {
        case .interval: return "p1.button.horizontal"
        case .roman:    return "building.columns.fill"
        case .degree:   return "control"
        case .integer:  return "0.square"
        case .symbol:   return "house.fill"
        }
    }
    
    public var label: String {
        return self.rawValue.capitalized
    }
}
