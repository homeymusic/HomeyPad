// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

/// Types of keyboards we can generate
public enum KeyboardLayout: Equatable, Hashable {
    
    /// All notes linearly right after one another
    case isomorphic(pitches: ArraySlice<Pitch>, tonicPitch: Pitch)
    
    /// All notes linearly right after one another
    case symmetric(pitches: ArraySlice<Pitch>, tonicPitch: Pitch)
    
    /// Traditional Piano layout with raised black keys over white keys
    case piano(pitches: ArraySlice<Pitch>,
               tonicPitch: Pitch,
               initialSpacerRatio: [IntegerNotation: CGFloat] = PianoSpacer.defaultInitialSpacerRatio,
               spacerRatio: [IntegerNotation: CGFloat] = PianoSpacer.defaultSpacerRatio,
               relativeBlackKeyWidth: CGFloat = PianoSpacer.defaultRelativeBlackKeyWidth,
               relativeBlackKeyHeight: CGFloat = PianoSpacer.defaultRelativeBlackKeyHeight)
    
    /// Guitar in arbitrary tuning, from first string (highest) to loweset string
    case guitar(allPitches: [Pitch], tonicPitch: Pitch, openStringsMIDI: [Int], fretcount: Int = 22)
    
}

