public enum NoteLabelChoice: String, CaseIterable, Identifiable {
    case letter    = "letter"
    case month     = "month"
    case midi      = "midi"
    case frequency = "frequency"

    public var id: String { self.rawValue }

    public var icon: String {
        switch self {
        case .letter: return "c.square"
        case .midi: return "48.square"
        case .frequency: return "water.waves"
        case .month: return "calendar"
        }
    }
    
    public var label: String {
        switch self {
        case .midi: return self.rawValue.uppercased()
        default: return self.rawValue.capitalized
        }
    }
}
