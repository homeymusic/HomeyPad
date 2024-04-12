public enum AccidentalChoice: String, CaseIterable, Identifiable {
    case flat  = "flat"
    case sharp = "sharp"

    public var id: String { self.rawValue }

    public var icon: String {
        switch self {
//        case .flat:  return "♭"
//        case .sharp: return "♯"
        case .flat:  return "b"
        case .sharp: return "#"
        }
    }
    
    public var label: String {
        return self.rawValue.capitalized
    }
    
}
