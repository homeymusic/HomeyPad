public enum PaletteChoice: String, CaseIterable, Identifiable {
    case subtle = "subtle"
    case loud = "loud"
    case ebonyIvory = "ebonyIvory"

    public var id: String { self.rawValue }

    public var icon: String {
        switch self {
        case .subtle: return "paintpalette"
        case .loud: return "paintpalette.fill"
        case .ebonyIvory: return "pianokeys"
        }
    }
}
