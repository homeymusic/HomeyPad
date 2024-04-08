// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

/// Types of keyboards we can generate
public enum KeyboardLayout: Equatable, Hashable {
    
    /// All notes linearly right after one another
    case isomorphic(allPitches: [Pitch], tonicPitch: Pitch, lowMIDI: Int, highMIDI: Int)
    
    /// All notes linearly right after one another
    case symmetric(allPitches: [Pitch], tonicPitch: Pitch, lowMIDI: Int, highMIDI: Int)
    
    /// Traditional Piano layout with raised black keys over white keys
    case piano(allPitches: [Pitch], tonicPitch: Pitch, lowMIDI: Int, highMIDI: Int,
               initialSpacerRatio: [IntegerNotation: CGFloat] = PianoSpacer.defaultInitialSpacerRatio,
               spacerRatio: [IntegerNotation: CGFloat] = PianoSpacer.defaultSpacerRatio,
               relativeBlackKeyWidth: CGFloat = PianoSpacer.defaultRelativeBlackKeyWidth,
               relativeBlackKeyHeight: CGFloat = PianoSpacer.defaultRelativeBlackKeyHeight)
    
    /// Guitar in arbitrary tuning, from first string (highest) to loweset string
    case guitar(allPitches: [Pitch], tonicPitch: Pitch, lowMIDI: Int, highMIDI: Int, openStringsMIDI: [Int], fretcount: Int = 22)
    
}

