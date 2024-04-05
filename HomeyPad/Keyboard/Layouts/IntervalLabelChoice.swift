public enum IntervalLabelChoice: String, CaseIterable, Identifiable {
    case symbol   = "symbol"
    case interval = "interval"
    case roman    = "roman"
    case degree   = "degree"
    case integer  = "integer"

    public var id: String { self.rawValue }

    public var icon: String {
        switch self {
        case .symbol:   return "house.fill"
        case .interval: return "p1.button.horizontal"
        case .roman:    return "building.columns.fill"
        case .degree:   return "control"
        case .integer:  return "0.square"
        }
    }
    
    public var label: String {
        return self.rawValue.capitalized
    }
}
