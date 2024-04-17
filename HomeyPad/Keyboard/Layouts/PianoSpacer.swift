import SwiftUI

public struct PianoSpacer {
    public static let defaultInitialSpacerRatio: [IntegerNotation: CGFloat] = [
        .zero: 0.0,
        .two: 3.0 / 16.0,
        .four: 6.0 / 16.0,
        .five: 0.0 / 16.0,
        .seven: 3.0 / 16.0,
        .nine: 4.5 / 16.0,
        .eleven: 6.0 / 16.0
    ]
    public static let defaultSpacerRatio: [IntegerNotation: CGFloat] = [
        .zero: 10.0 / 16.0,
        .two: 10.0 / 16.0,
        .four: 10.0 / 16.0,
        .five: 10.0 / 16.0,
        .seven: 8.5 / 16.0,
        .nine: 8.5 / 16.0,
        .eleven: 10.0 / 16.0
    ]
    public static let defaultRelativeBlackKeyWidth: CGFloat = 9.0 / 16.0
    
    /// Default value for Black Key Height
    public static let defaultRelativeBlackKeyHeight: CGFloat = 0.53

    @ObservedObject var viewConductor: ViewConductor
    public var initialSpacerRatio: [IntegerNotation: CGFloat] = PianoSpacer.defaultInitialSpacerRatio
    public var spacerRatio: [IntegerNotation: CGFloat] = PianoSpacer.defaultSpacerRatio
    public var relativeBlackKeyWidth: CGFloat = PianoSpacer.defaultRelativeBlackKeyWidth
    public var relativeBlackKeyHeight: CGFloat = PianoSpacer.defaultRelativeBlackKeyHeight
}

extension PianoSpacer {
    public var whiteMIDI: [Int] {
        var naturalMIDI: [Int] = []
        for midi in midiBoundedByNaturals where !Pitch.accidental(midi: midi) {
            naturalMIDI.append(midi)
        }
        return naturalMIDI
    }

    public func isBlackKey(_ midi: Int) -> Bool {
        Pitch.accidental(midi: midi)
    }

    public var initialSpacer: CGFloat {
        let pitchClass = Pitch.pitchClass(midi: midiBoundedByNaturals.first!)
        return initialSpacerRatio[pitchClass] ?? 0
    }

    public func space(midi: Int) -> CGFloat {
        let pitchClass = Pitch.pitchClass(midi: midi)
        return spacerRatio[pitchClass] ?? 0
    }

    public func whiteKeyWidth(_ width: CGFloat) -> CGFloat {
        width / CGFloat(whiteMIDI.count)
    }

    public func blackKeyWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * relativeBlackKeyWidth
    }

    public var midiBoundedByNaturals: ClosedRange<Int> {
        var colsBelow = viewConductor.layoutRowsCols.colsPerSide[.piano]!
        var colsAbove = viewConductor.layoutRowsCols.colsPerSide[.piano]!
                
        // if F .five or B .eleven are the tonic then the tritone will be off center
        if viewConductor.tonicPitch.pitchClass == .five {
            colsBelow = colsBelow - 1
        } else if viewConductor.tonicPitch.pitchClass == .eleven {
            colsAbove = colsAbove - 1
        }
        
        let naturalsBelowTritone = Array(Pitch.naturalMIDI.filter({$0 < viewConductor.tritoneMIDI}).suffix(colsBelow))
        let naturalsAboveTritone = Array(Pitch.naturalMIDI.filter({$0 > viewConductor.tritoneMIDI}).prefix(colsAbove))

        let lowIndex: Int = naturalsBelowTritone.min() ?? 0
        let highIndex: Int = naturalsAboveTritone.max() ?? 127
        
        return lowIndex...highIndex
    }

    public func initialSpacerWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * initialSpacer
    }

    public func lowerBoundSpacerWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * space(midi: viewConductor.lowMIDI)
    }

    public func blackKeySpacerWidth(_ width: CGFloat, midi: Int) -> CGFloat {
        whiteKeyWidth(width) * space(midi: midi)
    }
}
