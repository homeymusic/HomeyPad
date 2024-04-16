struct LayoutPalette: Decodable {
    var choices: [LayoutChoice: PaletteChoice] = defaultlayoutPalette
    
    static let defaultlayoutPalette: [LayoutChoice: PaletteChoice] = [
        .tonic:      .subtle,
        .isomorphic: .subtle,
        .symmetric:  .subtle,
        .piano:      .subtle,
        .strings:    .subtle
    ]
    
}
