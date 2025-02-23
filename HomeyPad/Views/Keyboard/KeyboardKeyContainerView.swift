import SwiftUI
import HomeyMusicKit

/// This handles the interaction for key, so the user can provide their own
/// visual representation.
public struct KeyboardKeyContainerView<Content: View>: View {
    let keyboardKeyView: (Pitch) -> Content

    var pitch: Pitch
    @ObservedObject var conductor: ViewConductor
    
    var zIndex: Int
    
    init(conductor: ViewConductor,
         pitch: Pitch,
         zIndex: Int = 0,
         @ViewBuilder keyboardKeyView: @escaping (Pitch) -> Content)
    {        
        self.conductor = conductor
        self.pitch = pitch
        self.zIndex = zIndex
        self.keyboardKeyView = keyboardKeyView
    }

    func rect(rect: CGRect) -> some View {
        keyboardKeyView(pitch)
            .preference(key: KeyRectsKey.self,
                        value: [KeyRectInfo(rect: rect,
                                            pitch: pitch,
                                            zIndex: zIndex)])
    }

    public var body: some View {
        GeometryReader { proxy in
            rect(rect: proxy.frame(in: .global))
        }
    }
}
