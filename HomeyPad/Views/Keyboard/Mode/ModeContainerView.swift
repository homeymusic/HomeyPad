import SwiftUI
import HomeyMusicKit

/// This handles the interaction for key, so the user can provide their own
/// visual representation.
public struct ModeContainerView<Content: View>: View {
    let modeView: (Mode) -> Content

    var mode: Mode
    @ObservedObject var conductor: ViewConductor
    
    var zIndex: Int
    
    init(conductor: ViewConductor,
         mode: Mode,
         zIndex: Int = 0,
         @ViewBuilder modeView: @escaping (Mode) -> Content)
    {
        self.conductor = conductor
        self.mode = mode
        self.zIndex = zIndex
        self.modeView = modeView
    }

    func rect(rect: CGRect) -> some View {
        modeView(mode)
            .preference(key: ModeRectsKey.self,
                        value: [ModeRectInfo(rect: rect,
                                            mode: mode,
                                            zIndex: zIndex)])
    }

    public var body: some View {
        GeometryReader { proxy in
            rect(rect: proxy.frame(in: .global))
        }
    }
}
