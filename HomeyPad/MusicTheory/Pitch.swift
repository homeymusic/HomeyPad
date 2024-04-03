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
        print("midi state (without func noteOn): \(self.midiState)")
        if self.midiState == .off {
            self.midiState = .on
            print("Pitch: note on \(self.midi)")
            print("midi state (within func noteOn): \(self.midiState)")
        }
    }
    
    public func noteOff() {
        print("midi state (func noteOff): \(self.midiState)")
        if self.midiState == .on {
            self.midiState = .off
            print("Pitch: note off \(self.midi)")
            print("midi state (within func noteOff): \(self.midiState)")
        }
    }
    
    public static func == (lhs: Pitch, rhs: Pitch) -> Bool {
        lhs.midi == rhs.midi
    }

}

extension Pitch: Identifiable, Hashable, Comparable  {
    public var id: UUID {
        return UUID()
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
}
