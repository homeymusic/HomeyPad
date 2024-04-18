import SwiftUI

enum ConsonanceDissonance: Int, CaseIterable, Identifiable, Comparable, Equatable {
    case tonic = 4
    case octave = 3
    case perfect = 2
    case consonant = 1
    case dissonant = 0
    
    var id: Int { self.rawValue }
    
    var icon: String {
        switch self {
        case .tonic: return "house.fill"       // Nitterhouse with fill
        case .octave: return "house.fill"      // Nitterhouse without fill
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
