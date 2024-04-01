import SwiftUI

enum LayoutChoice: String, CaseIterable, Identifiable {
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
    
    @Published var layoutChoice: LayoutChoice = .symmetric

    @Published var lowPitches = [
        LayoutChoice.isomorphic: Pitch(57),
        LayoutChoice.symmetric:  Pitch(53),
        LayoutChoice.piano:      Pitch(53),
        LayoutChoice.guitar:     Pitch(40)
    ]
    
    @Published var highPitches = [
        LayoutChoice.isomorphic: Pitch(75),
        LayoutChoice.symmetric:  Pitch(79),
        LayoutChoice.piano:      Pitch(79),
        LayoutChoice.guitar:     Pitch(86)
    ]
    
    @Published var tonicPitch: Pitch = Pitch(60)
    
    @Published var showHomePicker: Bool = false
        
    var pitchRange: ClosedRange<Pitch> {
        lowPitches[self.layoutChoice]!...highPitches[self.layoutChoice]!
    }

    func noteOn(pitch: Pitch, point: CGPoint) {
        print("note on \(pitch)")
    }
    
    func noteOff(pitch: Pitch) {
        print("note off \(pitch)")
    }
    
}

