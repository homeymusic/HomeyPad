import SwiftUI

public class TonicKeyboardModel: KeyboardModel {
    @Binding var tonicMIDI: Int
    
    init(tonicMIDI: Binding<Int>) {
        self._tonicMIDI = tonicMIDI
    }

    override func triggerEvents(from oldValue: Set<Pitch>, to newValue: Set<Pitch>) {
        let newPitches = newValue.subtracting(oldValue)
        
        for pitch in newPitches {
            tonicMIDI = Int(pitch.midi)
        }
    }
}
