struct Interval: Comparable, Equatable {
    public var pitch: Pitch
    public var tonicPitch: Pitch
    public var semitones: Int8
    public var intervalClass: IntegerNotation
    public var octaveDistance: Int8
    
    public init(pitch: Pitch, tonicPitch: Pitch) {
        self.pitch = pitch
        self.tonicPitch = tonicPitch
        self.semitones = pitch.semitones(to: tonicPitch)
        self.intervalClass = IntegerNotation(rawValue: modulo(self.semitones, 12))!
        self.octaveDistance = Int8(self.semitones / 12)
    }
    
    public var majorMinor: MajorMinor {
        switch intervalClass {
        case .one, .three, .eight, .ten: return .minor
        case .zero, .five, .six, .seven: return .neutral
        case .two, .four, .nine, .eleven: return .major
        }
    }
    
    public var consonanceDissonance: ConsonanceDissonance {
        if pitch == tonicPitch {
            return .tonic
        } else {
            switch intervalClass {
            case .zero: return .octave
            case .five, .seven: return .perfect
            case .three, .four, .eight, .nine: return .consonant
            case .one, .two, .six, .ten, .eleven: return .dissonant
            }
        }
    }
    
    public var pitchDirection: PitchDirection {
        var pitchDirection: PitchDirection = .ambiguous
        if self.semitones < 0 {
            pitchDirection = .downward
        } else if self.semitones > 0 {
            pitchDirection = .upward
        }
        return pitchDirection
    }
    
    static func < (lhs: Interval, rhs: Interval) -> Bool {
        lhs.consonanceDissonance < rhs.consonanceDissonance && lhs.majorMinor < rhs.majorMinor
    }
    
}
