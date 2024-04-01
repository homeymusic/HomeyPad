import CoreGraphics

public struct Pitch: Equatable, Hashable, Comparable, Strideable {
    
    public var midiNote: Int8
    public var pitchClass: IntegerNotation
    
    public init(_ midiNote: Int8) {
        self.midiNote = midiNote
        self.pitchClass = IntegerNotation(rawValue: modulo(self.midiNote, 12))!
    }
    
    public var accidental: Bool {
        switch self.pitchClass {
        case .one, .three, .six, .eight, .ten:
            return true
        case .zero, .two, .four, .five, .seven, .nine, .eleven:
            return false
        }
    }
    
    public func semitones(to next: Pitch) -> Int8 {
            midiNote - next.midiNote
    }

    public var intValue: Int {
        Int(midiNote)
    }

    public static func < (lhs: Pitch, rhs: Pitch) -> Bool {
        lhs.midiNote < rhs.midiNote
    }

    public func distance(to other: Pitch) -> Int8 {
        semitones(to: other)
    }

    public func advanced(by n: Int8) -> Pitch {
        Pitch(midiNote + n)
    }
}

struct Interval {
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
    
    public var mainColor: CGColor {
        #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1)
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
    
}
