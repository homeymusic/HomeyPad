import SwiftUI


// TODO: more levels:
// P1, P8: +4 House 100
// P4, P5: +3 Triangle 200
// m3, M6: +2 Diamond 300
// M3, m6: +1 Diamond 400
//     tt:  0 Stone 500
// M2, m7: -1 Stone 600
// m2, M7: -2 Stone 700

enum ConsonanceDissonance: Int, CaseIterable, Identifiable, Comparable, Equatable {
    case tonic = 4
    case octave = 3
    case perfect = 2
    case consonant = 1
    case dissonant = 0
    
    var id: Int { self.rawValue }
    
    var icon: String {
        switch self {
        case .tonic: return "house.fill"       // Nitterhouse
        case .octave: return "house.fill"      // Nitterhouse
        case .perfect: return "triangle.fill"
        case .consonant: return "diamond.fill"
        case .dissonant: return "circle.fill"
        }
    }

    var label: String {
        switch self {
        case .tonic: return "tonic"
        case .octave: return "octave"
        case .perfect: return "perfect"
        case .consonant: return "consonant"
        case .dissonant: return "dissonant"
        }
    }
    
    var fontWeight: Font.Weight {
        switch self {
        case .tonic: return     .semibold
        case .octave: return    .regular
        case .perfect: return   .regular
        case .consonant: return .regular
        case .dissonant: return .regular
        }
    }
    
    var imageScale: CGFloat {
        switch self {
        case .tonic:     1.0
        case .octave:    0.9
        case .perfect:   0.6
        case .consonant: 0.5
        case .dissonant: 0.4
        }
    }

    static func < (lhs: ConsonanceDissonance, rhs: ConsonanceDissonance) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
}
