// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

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

    public var pitches: ArraySlice<Pitch>
    public var tonicPitch: Pitch
    public var initialSpacerRatio: [IntegerNotation: CGFloat]
    public var spacerRatio: [IntegerNotation: CGFloat]
    public var relativeBlackKeyWidth: CGFloat = PianoSpacer.defaultRelativeBlackKeyWidth
    /// The smaller the number, the shorter the black keys appear. A value of 1 approximates an isomorphic keyboard
    public var relativeBlackKeyHeight: CGFloat = PianoSpacer.defaultRelativeBlackKeyHeight
}

extension PianoSpacer {
    public var whiteKeys: ArraySlice<Pitch> {
        var returnValue: ArraySlice<Pitch> = []
        for pitch in pitchesBoundedByNaturals where !pitch.accidental {
            returnValue.append(pitch)
        }
        return returnValue
    }

    public func isBlackKey(_ pitch: Pitch) -> Bool {
        pitch.accidental
    }

    public var initialSpacer: CGFloat {
        let pitchClass = pitches[pitches.startIndex].pitchClass
        return initialSpacerRatio[pitchClass] ?? 0
    }

    public func space(pitch: Pitch) -> CGFloat {
        let pitchClass = pitch.pitchClass
        return spacerRatio[pitchClass] ?? 0
    }

    public func whiteKeyWidth(_ width: CGFloat) -> CGFloat {
        width / CGFloat(whiteKeys.count)
    }

    public func blackKeyWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * relativeBlackKeyWidth
    }

    public var pitchesBoundedByNaturals: ArraySlice<Pitch> {
        var lowestIndex = pitches.startIndex
        let lowestPitch = pitches[lowestIndex]
        if lowestPitch.accidental {
            lowestIndex = lowestIndex - 1
        }
        var highestIndex = pitches.endIndex - 1
        let highestPitch = pitches[highestIndex]
        if highestPitch.accidental {
            highestIndex = highestIndex + 1
        }
        return pitches[lowestIndex...highestIndex]
    }

    public func initialSpacerWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * initialSpacer
    }

    public func lowerBoundSpacerWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * space(pitch: pitches[pitches.startIndex])
    }

    public func blackKeySpacerWidth(_ width: CGFloat, pitch: Pitch) -> CGFloat {
        whiteKeyWidth(width) * space(pitch: pitch)
    }
}
