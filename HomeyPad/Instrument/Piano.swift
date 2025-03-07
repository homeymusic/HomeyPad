import Foundation
import HomeyMusicKit
import MIDIKitIO

public class Piano: KeyboardInstrument {
    
    public init() {
        switch HomeyPad.formFactor {
        case .iPhone:
            super.init(instrumentType: .piano,
                       defaultRows: 0, minRows: 0, maxRows: 2,
                       defaultCols: 8, minCols: 4, maxCols: 11)
        case .iPad:
            super.init(instrumentType: .piano,
                       defaultRows: 0, minRows: 0, maxRows: 2,
                       defaultCols: 11, minCols: 4, maxCols: 30)
        }
    }
    
    public func nearbyNotes(forTonic tonic: Int, pitchDirection: PitchDirection) -> [Int] {
        
        let tritoneSemitones = pitchDirection == .downward ? -6 : +6
        let tritoneMIDI =  Int(tonic) + tritoneSemitones
        
        let naturalsPerSide = cols
        
        // Make sure naturalsPerSide is positive; if not, just return tritoneMIDI.
        guard naturalsPerSide > 0 else { return [tritoneMIDI] }
        
        // Find the natural note below tritoneMIDI.
        var lowerCount = 0
        var lowerBound = tritoneMIDI
        var candidate = tritoneMIDI - 1
        while lowerCount < naturalsPerSide {
            if Pitch.isNatural(candidate) {
                lowerBound = candidate
                lowerCount += 1
            }
            candidate -= 1
        }
        
        // Find the natural note above tritoneMIDI.
        var upperCount = 0
        var upperBound = tritoneMIDI
        candidate = tritoneMIDI + 1
        while upperCount < naturalsPerSide {
            if Pitch.isNatural(candidate) {
                upperBound = candidate
                upperCount += 1
            }
            candidate += 1
        }
        
        // Return all MIDI note numbers between the two natural notes.
        return Array(lowerBound...upperBound)
    }

}
