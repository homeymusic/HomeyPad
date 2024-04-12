enum Mode: Int, CaseIterable, Identifiable, Comparable, Equatable {
    case ionian               = 0
    case mixolydianPentatonic = 1
    case dorian               = 2
    case aeolianPentatonic    = 3
    case phrygian             = 4
    case lydian               = 5
    case ionianPentatonic     = 6
    case mixolydian           = 7
    case dorianPentatonic     = 8
    case aeolian              = 9
    case phrygianPentatonic   = 10
    case locrian              = 11
    
    var id: String { String(self.rawValue) }
    
    static func < (lhs: Mode, rhs: Mode) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    public var majorMinor: MajorMinor {
        switch self {
        case .ionian:               return .major
        case .mixolydianPentatonic: return .major
        case .dorian:               return .neutral
        case .aeolianPentatonic:    return .minor
        case .phrygian:             return .minor
        case .lydian:               return .major
        case .ionianPentatonic:     return .major
        case .mixolydian:           return .major
        case .dorianPentatonic:     return .neutral
        case .aeolian:              return .minor
        case .phrygianPentatonic:   return .minor
        case .locrian:              return .minor
        }
    }
    
    public var label: String {
        switch self {
        case .ionian:               return "ION"
        case .mixolydianPentatonic: return "mix"
        case .dorian:               return "DOR"
        case .aeolianPentatonic:    return "aeo"
        case .phrygian:             return "PHR"
        case .lydian:               return "LYD"
        case .ionianPentatonic:     return "ion"
        case .mixolydian:           return "MIX"
        case .dorianPentatonic:     return "dor"
        case .aeolian:              return "MIN"
        case .phrygianPentatonic:   return "phr"
        case .locrian:              return "LOC"
        }
    }
    
    public var pitchDirection: PitchDirection {
        switch self {
        case .ionian:               return .upward
        case .mixolydianPentatonic: return .downward
        case .dorian:               return .both
        case .aeolianPentatonic:    return .upward
        case .phrygian:             return .downward
        case .lydian:               return .upward
        case .ionianPentatonic:     return .upward
        case .mixolydian:           return .downward
        case .dorianPentatonic:     return .both
        case .aeolian:              return .upward
        case .phrygianPentatonic:   return .downward
        case .locrian:              return .downward
        }
    }
    
    public var chordShape: ChordShape {
        switch self {
        case .ionian:               return .positive
        case .mixolydianPentatonic: return .positive
        case .dorian:               return .positiveNegative
        case .aeolianPentatonic:    return .negative
        case .phrygian:             return .negative
        case .lydian:               return .positiveInversion
        case .ionianPentatonic:     return .positive
        case .mixolydian:           return .positive
        case .dorianPentatonic:     return .positiveNegative
        case .aeolian:              return .negative
        case .phrygianPentatonic:   return .negative
        case .locrian:              return .negativeInversion
        }
    }

}
