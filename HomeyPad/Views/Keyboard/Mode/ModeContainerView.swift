//{ mode, columnIndex in
//   ModeView(mode: mode,
//            columnIndex: columnIndex,
//            thisConductor: modeConductor,
//            viewConductor: viewConductor,
//            modeConductor: modeConductor
//            )
//   .aspectRatio(2.0, contentMode: .fit)
//}
//

import SwiftUI
import HomeyMusicKit

/// This handles the interaction for a mode so the user can provide their own visual representation.
public struct ModeContainerView: View {
    // Update the closure type to accept a Mode and a columnIndex.
    var mode: Mode
    @ObservedObject var conductor: ViewConductor
    var columnIndex: Int  // Pass the column position from ModePickerView.
    var modeView: ModeView
    init(conductor: ViewConductor,
         mode: Mode,
         columnIndex: Int)
    {
        self.conductor = conductor
        self.mode = mode
        self.columnIndex = columnIndex
        self.modeView = ModeView(mode: mode,  columnIndex: columnIndex, thisConductor: conductor)
    }

    func rect(rect: CGRect) -> some View {
        // Pass both the mode and the columnIndex to the modeView closure.
        modeView
            .preference(key: ModeRectsKey.self,
                        value: [ModeRectInfo(rect: rect,
                                             mode: mode)])
    }

    public var body: some View {
        GeometryReader { proxy in
            rect(rect: proxy.frame(in: .global))
        }
    }
}
