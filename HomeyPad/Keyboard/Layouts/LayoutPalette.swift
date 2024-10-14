import HomeyMusicKit

struct LayoutPalette: Codable, Equatable {
    var choices: [LayoutChoice: PaletteChoice] = defaultLayoutPalette
    
    static let defaultLayoutPalette: [LayoutChoice: PaletteChoice] = [
        .tonic:      .subtle,
        .isomorphic: .subtle,
        .dualistic:  .subtle,
        .piano:      .subtle,
        .strings:    .subtle
    ]
    
    var outlineChoice: [LayoutChoice: Bool] = defaultLayoutOutline
            
    static let defaultLayoutOutline: [LayoutChoice: Bool] = [
        .tonic:      true,
        .isomorphic: true,
        .dualistic:  true,
        .piano:      true,
        .strings:    true
    ]

    static let outlineLabel: String = "Outline"
}
