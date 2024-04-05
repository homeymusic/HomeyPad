public enum PaletteChoice: String, CaseIterable, Identifiable {
    case subtle = "subtle"
    case loud = "loud"
    case ebonyIvory = "piano"

    public var id: String { self.rawValue }

    public var icon: String {
        switch self {
        case .subtle: return "paintpalette"
        case .loud: return "paintpalette.fill"
        case .ebonyIvory: return "rectangle.righthalf.filled"
        }
    }
    
    public var label: String {
        return self.rawValue.capitalized
    }
    
}
