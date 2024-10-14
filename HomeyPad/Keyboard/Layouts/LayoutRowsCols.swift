import SwiftUI
import HomeyMusicKit

struct LayoutRowsCols: Codable, Equatable {
    
    var rowsPerSide: [LayoutChoice: Int] = defaultRowsPerSide
    var colsPerSide: [LayoutChoice: Int] = defaultColsPerSide
    
    static let defaultRowsPerSide: [LayoutChoice: Int] = [
        .tonic:      0,
        .isomorphic: 0,
        .dualistic:  0,
        .piano:      0,
        .strings:    6
    ]
    
    static let minRowsPerSide: [LayoutChoice: Int] = [
        .tonic:      0,
        .isomorphic: 0,
        .dualistic:  0,
        .piano:      0,
        .strings:    4
    ]
    
    static let maxRowsPerSide: [LayoutChoice: Int] = [
        .tonic:      0,
        .isomorphic: 5,
        .dualistic:  2,
        .piano:      2,
        .strings:    26
    ]

    static let defaultColsPerSide: [LayoutChoice: Int] = switch HomeyPad.formFactor {
    case .iPhone:
        [
            .tonic:      6,
            .isomorphic: 9,
            .dualistic:  13,
            .piano:      8,
            .strings:    26
        ]
    case .iPad:
        [
            .tonic:      6,
            .isomorphic: 12 ,
            .dualistic:  18,
            .piano:      11,
            .strings:    26
        ]
    }
        
    static let minColsPerSide: [LayoutChoice: Int] = [
        .tonic:      6,
        .isomorphic: 6,
        .dualistic:  6,
        .piano:      4,
        .strings:    26
    ]
    
    static let maxColsPerSide: [LayoutChoice: Int] = switch HomeyPad.formFactor {
    case .iPhone:
        [
            .tonic:      6,
            .isomorphic: 18,
            .dualistic:  18,
            .piano:      11,
            .strings:    26
        ]
    case .iPad:
        [
            .tonic:      6,
            .isomorphic: 18,
            .dualistic:  30,
            .piano:      18,
            .strings:    26
        ]
    }

}
