struct LayoutRowsCols: Codable, Equatable {
    
    var rowsPerSide: [LayoutChoice: Int] = defaultRowsPerSide
    var colsPerSide: [LayoutChoice: Int] = defaultColsPerSide
    
    static let defaultRowsPerSide: [LayoutChoice: Int] = [
        .tonic:      0,
        .isomorphic: 0,
        .symmetric:  0,
        .piano:      0,
        .strings:    6
    ]
    
    static let minRowsPerSide: [LayoutChoice: Int] = [
        .tonic:      0,
        .isomorphic: 0,
        .symmetric:  0,
        .piano:      0,
        .strings:    4
    ]
    
    static let maxRowsPerSide: [LayoutChoice: Int] = [
        .tonic:      0,
        .isomorphic: 4,
        .symmetric:  2,
        .piano:      2,
        .strings:    26
    ]

    static let defaultColsPerSide: [LayoutChoice: Int] = [
        .tonic:      6,
        .isomorphic: 9,
        .symmetric:  13,
        .piano:      8,
        .strings:    26
    ]
    
    static let minColsPerSide: [LayoutChoice: Int] = [
        .tonic:      6,
        .isomorphic: 6,
        .symmetric:  6,
        .piano:      4,
        .strings:    26
    ]
    
    static let maxColsPerSide: [LayoutChoice: Int] = [
        .tonic:      6,
        .isomorphic: 18,
        .symmetric:  18,
        .piano:      11,
        .strings:    26
    ]

}
