import SwiftUI
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

enum PitchDirection: Int8, CaseIterable, Identifiable {
    case upward    = 1
    case ambiguous = 0
    case downward  = -1
    
    var id: Int8 { self.rawValue }
}

