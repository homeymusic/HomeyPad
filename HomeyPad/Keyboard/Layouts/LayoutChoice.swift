public enum LayoutChoice: String, CaseIterable, Identifiable, Codable {
    case tonic = "tonic"
    case isomorphic = "isomorphic"
    case symmetric = "symmetric"
    case piano = "piano"
    case strings = "strings"
    
    public var id: String { self.rawValue }
    
    public var icon: String {
        switch self {
        case .tonic: return "house"
        case .isomorphic: return "rectangle.split.2x1"
        case .symmetric: return "rectangle.split.2x2"
        case .piano: return "pianokeys"
        case .strings: return "guitars"
        }
    }
    
    public static var allCases: [LayoutChoice] {
        return [.isomorphic, .symmetric, .piano, .strings]
    }
}
