import HomeyMusicKit

struct LayoutPalette: Codable, Equatable {
    var choices: [LayoutChoice: PaletteChoice] = defaultLayoutPalette
    
    static let defaultLayoutPalette: [LayoutChoice: PaletteChoice] = [
        .tonic:      .subtle,
        .mode:       .subtle,
        .isomorphic: .subtle,
        .diamanti:  .subtle,
        .piano:      .subtle,
        .strings:    .subtle
    ]
    
    var outlineChoice: [LayoutChoice: Bool] = defaultLayoutOutline
            
    static let defaultLayoutOutline: [LayoutChoice: Bool] = [
        .tonic:      true,
        .mode:       true,
        .isomorphic: true,
        .diamanti:  true,
        .piano:      true,
        .strings:    true
    ]

    static let outlineLabel: String = "Outline"
}
