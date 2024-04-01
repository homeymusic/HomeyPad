// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

/// Types of keyboards we can generate
public enum KeyboardLayout: Equatable, Hashable {
    
    /// All notes linearly right after one another
    case isomorphic(pitchRange: ClosedRange<Pitch>)
    
    /// All notes linearly right after one another
    case symmetric(pitchRange: ClosedRange<Pitch>)
    
    /// Traditional Piano layout with raised black keys over white keys
    case piano(pitchRange: ClosedRange<Pitch>,
               initialSpacerRatio: [IntegerNotation: CGFloat] = PianoSpacer.defaultInitialSpacerRatio,
               spacerRatio: [IntegerNotation: CGFloat] = PianoSpacer.defaultSpacerRatio,
               relativeBlackKeyWidth: CGFloat = PianoSpacer.defaultRelativeBlackKeyWidth,
               relativeBlackKeyHeight: CGFloat = PianoSpacer.defaultRelativeBlackKeyHeight)
    
    /// Guitar in arbitrary tuning, from first string (highest) to loweset string
    case guitar(openPitches: [Pitch] = [Pitch(64), Pitch(59), Pitch(55), Pitch(50), Pitch(45), Pitch(40)], fretcount: Int = 22)
    
}

