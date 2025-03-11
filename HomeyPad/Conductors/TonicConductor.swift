import SwiftUI
import HomeyMusicKit

final class TonicConductor: ViewConductor {
    init(
        latching: Bool = false,
        tonalContext: TonalContext
    ) {
        super.init(
            layoutChoice: .tonic,
            latching: latching,
            sendTonicState: true,
            tonalContext: tonalContext
        )
    }
    
}
