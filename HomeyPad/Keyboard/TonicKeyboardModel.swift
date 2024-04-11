import SwiftUI

public class TonicKeyboardModel: KeyboardModel {
    
    override func triggerEvents(from oldValue: Set<Pitch>, to newValue: Set<Pitch>) {
        let newPitches = newValue.subtracting(oldValue)
        let oldPitches = oldValue.subtracting(newValue)
        
        for pitch in newPitches {
            print("Tonic Button On \(pitch.midi)")
        }
        
        for pitch in oldPitches {
            print("Tonic Button Off \(pitch.midi)")
        }
    }
}
