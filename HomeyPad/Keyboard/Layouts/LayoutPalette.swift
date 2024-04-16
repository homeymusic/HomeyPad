struct LayoutPalette: Codable, Equatable {
    var choices: [LayoutChoice: PaletteChoice] = defaultLayoutPalette
    
    static let defaultLayoutPalette: [LayoutChoice: PaletteChoice] = [
        .tonic:      .subtle,
        .isomorphic: .subtle,
        .symmetric:  .subtle,
        .piano:      .subtle,
        .strings:    .subtle
    ]
    
}
