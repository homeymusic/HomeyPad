import SwiftUI
import HomeyMusicKit

final class TonicConductor: ViewConductor {
    init(
        stringsLayoutChoice: StringsLayoutChoice = .violin,
        latching: Bool = false,
        layoutPalette: LayoutPalette = LayoutPalette(),
        layoutLabel: LayoutLabel = LayoutLabel(),
        tonalContext: TonalContext
    ) {
        super.init(
            layoutChoice: .tonic,
            stringsLayoutChoice: stringsLayoutChoice,
            latching: latching,
            layoutPalette: layoutPalette,
            layoutLabel: layoutLabel,
            sendTonicState: true,
            tonalContext: tonalContext
        )
    }
    
}
