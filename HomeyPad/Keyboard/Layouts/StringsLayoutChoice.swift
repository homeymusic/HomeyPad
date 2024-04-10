public enum StringsLayoutChoice: String, CaseIterable, Identifiable {
    case guitar = "guitar"
    case bass   = "bass"
    case violin = "violin"

    public var id: String { self.rawValue }
    
    public var icon: String {
        rawValue
    }
    
    public var openStringsMIDI: [Int] {
        switch self {
        case .guitar:
            [64, 59, 55, 50, 45, 40]
        case .bass:
            [55, 50, 45, 40]
        case .violin:
            [76, 69, 62, 55]
        }
    }
}


