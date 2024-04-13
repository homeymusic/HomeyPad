import SwiftUI

public enum MIDIState {
    case on, off
}

public class Pitch: ObservableObject, Equatable {
    
    public var midi: Int8
    public var pitchClass: IntegerNotation
    @Published public var midiState: MIDIState = .off
    @Published public var isTonic: Bool = false

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
    
    func letter(_ accidental: AccidentalChoice) -> String {
        switch pitchClass {
        case .zero:
            "C"
        case .one:
            accidental == .sharp ? "C♯" : "D♭"
        case .two:
            "D"
        case .three:
            accidental == .sharp ? "D♯" : "E♭"
        case .four:
            "E"
        case .five:
            "F"
        case .six:
            accidental == .sharp ? "F♯" : "G♭"
        case .seven:
            "G"
        case .eight:
            accidental == .sharp ? "G♯" : "A♭"
        case .nine:
            "A"
        case .ten:
            accidental == .sharp ? "A♯" : "B♭"
        case .eleven:
            "B"
        }
    }
    
    func fixedDo(_ accidental: AccidentalChoice) -> String {
        switch pitchClass {
        case .zero:
            "Do"
        case .one:
            accidental == .sharp ? "Do♯" : "Re♭"
        case .two:
            "Re"
        case .three:
            accidental == .sharp ? "Re♯" : "Mi♭"
        case .four:
            "Mi"
        case .five:
            "Fa"
        case .six:
            accidental == .sharp ? "Fa♯" : "Sol♭"
        case .seven:
            "Sol"
        case .eight:
            accidental == .sharp ? "Sol♯" : "La♭"
        case .nine:
            "La"
        case .ten:
            accidental == .sharp ? "La♯" : "Si♭"
        case .eleven:
            "Si"
        }
    }

    var mode: Mode {
        Mode.allCases[Int(self.pitchClass.rawValue)]
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
