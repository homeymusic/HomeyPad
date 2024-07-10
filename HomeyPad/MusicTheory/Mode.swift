enum Mode: Int, CaseIterable, Identifiable, Comparable, Equatable {
    case ionian               = 0
    case phrygian             = 4
    case mixolydian           = 7
    case aeolian              = 9
    case dorian               = 2
    case lydian               = 5
    case locrian              = 11
    case ionianPentatonic     = 6
    case phrygianPentatonic   = 10
    case mixolydianPentatonic = 1
    case aeolianPentatonic    = 3
    case dorianPentatonic     = 8
    
    var id: String { String(self.rawValue) }
    
    static func < (lhs: Mode, rhs: Mode) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    public var scale: Scale {
        switch self {
        case .ionian, .dorian, .phrygian, .lydian, .mixolydian, .aeolian, .locrian:
            return .heptatonic
        case .mixolydianPentatonic, .aeolianPentatonic, .ionianPentatonic, .dorianPentatonic, .phrygianPentatonic:
            return .pentatonic
        }
    }
    
    public var majorMinor: MajorMinor {
        switch self {
        case .ionian, .ionianPentatonic, .lydian, .mixolydian, .mixolydianPentatonic:
            return .major
        case .phrygian, .phrygianPentatonic, .locrian, .aeolian, .aeolianPentatonic:
            return .minor
        case .dorian, .dorianPentatonic:
            return .neutral
        }
    }
    
    public var label: String {
        switch self {
        case .ionian:               return "ionian"
        case .mixolydianPentatonic: return "mixolydian pentatonic"
        case .dorian:               return "dorian"
        case .aeolianPentatonic:    return "aeolian pentatonic"
        case .phrygian:             return "phrygian"
        case .lydian:               return "lydian"
        case .ionianPentatonic:     return "ionian pentatonic"
        case .mixolydian:           return "mixolydian"
        case .dorianPentatonic:     return "dorian pentatonic"
        case .aeolian:              return "aeolian"
        case .phrygianPentatonic:   return "phrygian pentatonic"
        case .locrian:              return "locrian"
        }
    }
    
    public var shortHand: String {
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
        case .aeolian:              return "AEO"
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

    public var letter: String {
        let pitch: Pitch = Pitch(Int8(self.rawValue))
        return pitch.letter(pitchDirection == .upward || pitchDirection == .both ? .flat : .sharp)
    }
}

enum Scale: Int, CaseIterable, Identifiable, Comparable, Equatable {
    case pentatonic = 5
    case heptatonic = 7
    
    var id: String { String(self.rawValue) }
    
    static func < (lhs: Scale, rhs: Scale) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    public var icon: String {
        switch self {
        case .heptatonic: return "7.square"
        case .pentatonic: return "pentagon.fill"
        }
    }
}
