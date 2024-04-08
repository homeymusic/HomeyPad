import SwiftUI

public enum MIDIState {
    case on, off
}

public class Pitch: ObservableObject, Equatable {
    
    public var midi: Int8
    public var pitchClass: IntegerNotation
    @Published public var midiState: MIDIState = .off
    
    public init(_ midi: Int8) {
        self.midi = midi
        self.pitchClass = Pitch.pitchClass(midi: Int(self.midi))
    }
    
    class func pitchClass(midi: Int) -> IntegerNotation {
        IntegerNotation(rawValue: Int8(modulo(Int(midi), 12)))!
    }
    
    public var accidental: Bool {
        Pitch.accidental(midi: Int(self.midi))
    }
    
    class func accidental(midi: Int) -> Bool {
        switch IntegerNotation(rawValue: Int8(modulo(midi, 12)))! {
        case .one, .three, .six, .eight, .ten:
            return true
        case .zero, .two, .four, .five, .seven, .nine, .eleven:
            return false
        }
    }
    
    public func semitones(to next: Pitch) -> Int8 {
        midi - next.midi
    }
    
    public var octave: Int {
        Int(self.midi / 12) - 1
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
        self.midiState = .on
        print("Pitch: note on \(self.midi)")
    }
    
    public func noteOff() {
        self.midiState = .off
        print("Pitch: note off \(self.midi)")
    }
    
    
    public static func == (lhs: Pitch, rhs: Pitch) -> Bool {
        lhs.midi == rhs.midi
    }
    
    var letter: String {
        switch pitchClass {
        case .zero:
            "C"
        case .one:
            "C♯D♭"
        case .two:
            "D"
        case .three:
            "D♯E♭"
        case .four:
            "E"
        case .five:
            "F"
        case .six:
            "F♯G♭"
        case .seven:
            "G"
        case .eight:
            "G♯A♭"
        case .nine:
            "A"
        case .ten:
            "A♯B♭"
        case .eleven:
            "B"
        }
    }
    
    var fixedDo: String {
        switch pitchClass {
        case .zero:
            "Do"
        case .one:
            "Do♯Re♭"
        case .two:
            "Re"
        case .three:
            "Re♯Mi♭"
        case .four:
            "Mi"
        case .five:
            "Fa"
        case .six:
            "Fa♯Sol♭"
        case .seven:
            "Sol"
        case .eight:
            "Sol♯La♭"
        case .nine:
            "La"
        case .ten:
            "La♯Si♭"
        case .eleven:
            "Si"
        }
    }
    
}

extension Pitch: Identifiable, Hashable, Comparable  {
    public var id: Int8 {
        return self.midi
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
}
