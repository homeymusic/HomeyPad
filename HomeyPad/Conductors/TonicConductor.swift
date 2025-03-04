import SwiftUI
import HomeyMusicKit

final class TonicConductor: ViewConductor {
    init(
        accidental: Accidental,
        stringsLayoutChoice: StringsLayoutChoice = .violin,
        latching: Bool = false,
        layoutPalette: LayoutPalette = LayoutPalette(),
        layoutLabel: LayoutLabel = LayoutLabel(),
        layoutRowsCols: LayoutRowsCols = LayoutRowsCols(),
        tonalContext: TonalContext
    ) {
        super.init(
            accidental: accidental,
            layoutChoice: .tonic,
            stringsLayoutChoice: stringsLayoutChoice,
            latching: latching,
            layoutPalette: layoutPalette,
            layoutLabel: layoutLabel,
            layoutRowsCols: layoutRowsCols,
            sendTonicState: true,
            tonalContext: tonalContext
        )
    }
    
}
