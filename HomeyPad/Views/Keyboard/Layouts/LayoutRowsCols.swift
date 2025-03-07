import SwiftUI
import HomeyMusicKit

struct LayoutRowsCols: Codable, Equatable {
    
    var rowsPerSide: [LayoutChoice: Int] = defaultRowsPerSide
    var colsPerSide: [LayoutChoice: Int] = defaultColsPerSide
    
    static let defaultRowsPerSide: [LayoutChoice: Int] = [
        .tonic:      0,
        .isomorphic: 0,
        .zeena:  0,
        .piano:      0,
        .strings:    6
    ]
    
    static let minRowsPerSide: [LayoutChoice: Int] = [
        .tonic:      0,
        .isomorphic: 0,
        .zeena:  0,
        .piano:      0,
        .strings:    4
    ]
    
    static let maxRowsPerSide: [LayoutChoice: Int] = [
        .tonic:      0,
        .isomorphic: 5,
        .zeena:  2,
        .piano:      2,
        .strings:    26
    ]

    static let defaultColsPerSide: [LayoutChoice: Int] = switch HomeyPad.formFactor {
    case .iPhone:
        [
            .tonic:      6,
            .isomorphic: 8,
            .zeena:  13,
            .piano:      8,
            .strings:    26
        ]
    case .iPad:
        [
            .tonic:      6,
            .isomorphic: 13,
            .zeena:  18,
            .piano:      11,
            .strings:    26
        ]
    }
        
    static let minColsPerSide: [LayoutChoice: Int] = [
        .tonic:      6,
        .isomorphic: 6,
        .zeena:  6,
        .piano:      4,
        .strings:    26
    ]
    
    static let maxColsPerSide: [LayoutChoice: Int] = switch HomeyPad.formFactor {
    case .iPhone:
        [
            .tonic:      6,
            .isomorphic: 18,
            .zeena:  18,
            .piano:      11,
            .strings:    26
        ]
    case .iPad:
        [
            .tonic:      6,
            .isomorphic: 18,
            .zeena:  30,
            .piano:      30,
            .strings:    26
        ]
    }

}
