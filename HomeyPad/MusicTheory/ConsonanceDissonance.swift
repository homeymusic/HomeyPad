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
        case .octave: return "house"           // Nitterhouse without fill
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
    
    var imageScale: Image.Scale {
        switch self {
        case .tonic:     .large
        case .octave:    .large
        case .perfect:   .medium
        case .consonant: .small
        case .dissonant: .small
        }
    }


    var fontWeight: Font.Weight {
        switch self {
        case .tonic:     .bold
        case .octave:    .medium
        case .perfect:   .regular
        case .consonant: .light
        case .dissonant: .light
        }
    }
    static func < (lhs: ConsonanceDissonance, rhs: ConsonanceDissonance) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
}
