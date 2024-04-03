public enum MIDIState {
    case on, off
}

public struct Pitch: Equatable, Hashable, Comparable {
    
    public var midi: Int8
    public var pitchClass: IntegerNotation
    public var midiState: MIDIState = .off
    
    public init(_ midi: Int8) {
        self.midi = midi
        self.pitchClass = IntegerNotation(rawValue: modulo(self.midi, 12))!
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
        midi - next.midi
    }
    
    public var intValue: Int {
        Int(midi)
    }
    
    public static func < (lhs: Pitch, rhs: Pitch) -> Bool {
        lhs.midi < rhs.midi
    }
    
    public func distance(to other: Pitch) -> Int8 {
        semitones(to: other)
    }
    
    public func noteOn() {
        print("Pitch: note on \(self.midi)")
    }
    
    public func noteOff() {
        print("Pitch: note off \(self.midi)")
    }
    
}
