public enum StringsLayoutChoice: String, CaseIterable, Identifiable {
    case violin = "violin"
    case cello  = "cello"
    case bass   = "bass"
    case banjo  = "banjo"
    case guitar = "guitar"
    
    public var id: String { self.rawValue }
    
    public var label: String {
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
        case .cello:
            [69, 62, 55, 48]
        case .banjo:
            [62, 59, 55, 50, 62]
        }
    }
}


