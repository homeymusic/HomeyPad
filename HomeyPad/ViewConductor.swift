//
//  swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/24/24.
//

import SwiftUI

enum Pad: String, CaseIterable, Identifiable {
    case isomorphic = "isomorphic"
    case symmetric = "symmetric"
    case piano = "piano"
    case guitar = "guitar"

    var id: String { self.rawValue }

    var icon: String {
        switch self {
            case .isomorphic: return "rectangle.split.2x1"
            case .symmetric: return "rectangle.split.2x2"
            case .piano: return "pianokeys"
            case .guitar: return "guitars"
        }
    }
}

class ViewConductor: ObservableObject {
    
    @Published var pad: Pad = .symmetric

    @Published var lowPitches = [
        Pad.isomorphic: Pitch(57),
        Pad.symmetric:  Pitch(53),
        Pad.piano:      Pitch(53),
        Pad.guitar:     Pitch(40)
    ]
    
    @Published var highPitches = [
        Pad.isomorphic: Pitch(75),
        Pad.symmetric:  Pitch(79),
        Pad.piano:      Pitch(79),
        Pad.guitar:     Pitch(86)
    ]
    
    @Published var tonicPitch: Pitch = Pitch(60)
    
    @Published var showHomePicker: Bool = false
    
    var pitchRange: ClosedRange<Pitch> {
        lowPitches[self.pad]!...highPitches[self.pad]!
    }

    func noteOn(pitch: Pitch, point: CGPoint) {
        print("note on \(pitch)")
    }
    
    func noteOff(pitch: Pitch) {
        print("note off \(pitch)")
    }
    
}

