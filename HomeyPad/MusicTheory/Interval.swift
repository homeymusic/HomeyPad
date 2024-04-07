struct Interval: Comparable, Equatable {
    public var pitch: Pitch
    public var tonicPitch: Pitch
    public var semitones: Int8
    public var intervalClass: IntegerNotation
    
    public init(pitch: Pitch, tonicPitch: Pitch) {
        self.pitch = pitch
        self.tonicPitch = tonicPitch
        self.semitones = pitch.semitones(to: tonicPitch)
        self.intervalClass = IntegerNotation(rawValue: modulo(self.semitones, 12))!
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
       
    static func < (lhs: Interval, rhs: Interval) -> Bool {
        lhs.consonanceDissonance < rhs.consonanceDissonance && lhs.majorMinor < rhs.majorMinor
    }
    
    var upwardPitchMovement: Bool {
        true
    }
    
    var degree: String {
        let accidental = upwardPitchMovement ? "♭" : "♯"
        let prefix = upwardPitchMovement ? "" : "<"
        let caret = "\u{0302}"
        let tritone = upwardPitchMovement ? "\(prefix)♭5\(caret)" : "\(prefix)♯5\(caret)"
        
        switch intervalClass {
        case .zero:
            return "\(prefix)1\(caret)"
        case .one:
            return "\(prefix)\(accidental)2\(caret)"
        case .two:
            return "\(prefix)2\(caret)"
        case .three:
            return "\(prefix)\(accidental)3\(caret)"
        case .four:
            return "\(prefix)3\(caret)"
        case .five:
            return "\(prefix)4\(caret)"
        case .six:
            return tritone
        case .seven:
            return "\(prefix)5\(caret)"
        case .eight:
            return "\(prefix)\(accidental)6\(caret)"
        case .nine:
            return "\(prefix)6\(caret)"
        case .ten:
            return "\(prefix)\(accidental)7\(caret)"
        case .eleven :
            return "\(prefix)7\(caret)"
        }
    }
    
    var roman: String {
        let accidental = upwardPitchMovement ? "♭" : "♯"
        let prefix = upwardPitchMovement ? "" : "<"
        let tritone = upwardPitchMovement ? "\(prefix)♯IV♭V" : "\(prefix)♯V♭IV"
        
        switch intervalClass {
        case .zero:
            return "\(prefix)I"
        case .one:
            return "\(prefix)\(accidental)II"
        case .two:
            return "\(prefix)II"
        case .three:
            return "\(prefix)\(accidental)III"
        case .four:
            return "\(prefix)III"
        case .five:
            return "\(prefix)IV"
        case .six:
            return tritone
        case .seven:
            return "\(prefix)V"
        case .eight:
            return "\(prefix)\(accidental)VI"
        case .nine:
            return "\(prefix)VI"
        case .ten:
            return "\(prefix)\(accidental)VII"
        case .eleven :
            return "\(prefix)VII"
        }
    }
    
    var interval: String {
        switch intervalClass {
        case .zero:
            return "\(upwardPitchMovement ? "" : "<")P1"
        case .one:
            return "m2"
        case .two:
            return "M2"
        case .three:
            return "m3"
        case .four:
            return "M3"
        case .five:
            return "P4"
        case .six:
            return "tt"
        case .seven:
            return "P5"
        case .eight:
            return "m6"
        case .nine:
            return "M6"
        case .ten:
            return "m7"
        case .eleven:
            return "M7"
        }
    }
    
    var movableDo: String {
        switch intervalClass {
        case .zero:
            "Do"
        case .one:
            "Di Ra"
        case .two:
            "Re"
        case .three:
            "Ri Me"
        case .four:
            "Mi"
        case .five:
            "Fa"
        case .six:
            "Fi Se"
        case .seven:
            "Sol"
        case .eight:
            "Si Le"
        case .nine:
            "La"
        case .ten:
            "Li Te"
        case .eleven:
            "Ti"
        }
    }

}

