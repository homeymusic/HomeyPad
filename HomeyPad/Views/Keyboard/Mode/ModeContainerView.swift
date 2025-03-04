import SwiftUI
import HomeyMusicKit

/// This handles the interaction for a mode so the user can provide their own visual representation.
public struct ModeContainerView<Content: View>: View {
    // Update the closure type to accept a Mode and a columnIndex.
    let modeView: (Mode, Int) -> Content

    var mode: Mode
    @ObservedObject var conductor: ViewConductor
    var columnIndex: Int  // Pass the column position from ModePickerView.
    
    init(conductor: ViewConductor,
         mode: Mode,
         columnIndex: Int,
         @ViewBuilder modeView: @escaping (Mode, Int) -> Content)
    {
        self.conductor = conductor
        self.mode = mode
        self.columnIndex = columnIndex
        self.modeView = modeView
    }

    func rect(rect: CGRect) -> some View {
        // Pass both the mode and the columnIndex to the modeView closure.
        modeView(mode, columnIndex)
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
