struct LayoutPalette: Codable, Equatable {
    var choices: [LayoutChoice: PaletteChoice] = defaultLayoutPalette
    
    static let defaultLayoutPalette: [LayoutChoice: PaletteChoice] = [
        .tonic:      .loud,
        .isomorphic: .subtle,
        .symmetric:  .subtle,
        .piano:      .subtle,
        .strings:    .subtle
    ]
    
    var outlineChoice: [LayoutChoice: Bool] = defaultLayoutOutline
            
    static let defaultLayoutOutline: [LayoutChoice: Bool] = [
        .tonic:      true,
        .isomorphic: true,
        .symmetric:  true,
        .piano:      true,
        .strings:    true
    ]

    static let outlineLabel: String = "Outline"
}
