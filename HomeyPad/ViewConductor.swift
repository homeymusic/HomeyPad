import SwiftUI

class ViewConductor: ObservableObject {
    
    var allPitches = [Pitch]()

    init() {
        for midi: Int8 in 0...127 {
            allPitches.append(Pitch(midi))
        }
    }

    @Published var layoutChoice: LayoutChoice = .symmetric  {
        willSet { allPitchesNoteOff() }
    }

    @Published var paletteChoice: PaletteChoice = .subtle

    func allPitchesNoteOff() {
        self.allPitches.forEach {pitch in
            pitch.noteOff()
        }
    }

    @Published var showTonicPicker: Bool = false
                
    @Published var tonicMIDI: Int = 60

    @Published var lowMIDI: [LayoutChoice: Int] = [
        LayoutChoice.isomorphic: 57,
        LayoutChoice.symmetric:  53,
        LayoutChoice.piano:      53,
        LayoutChoice.guitar:     40
    ]
    
    @Published var highMIDI: [LayoutChoice: Int] = [
        LayoutChoice.isomorphic: 75,
        LayoutChoice.symmetric:  79,
        LayoutChoice.piano:      79,
        LayoutChoice.guitar:     86
    ]
    
    var tonicPitch: Pitch {
        self.allPitches[self.tonicMIDI]
    }
    
    var pitches: ArraySlice<Pitch> {
        return allPitches[lowMIDI[self.layoutChoice]!...highMIDI[self.layoutChoice]!]
    }
    
}
