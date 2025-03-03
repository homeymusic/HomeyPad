import SwiftUI
import HomeyMusicKit

/// This handles the interaction for key, so the user can provide their own
/// visual representation.
public struct PitchContainerView<Content: View>: View {
    let pitchView: (Pitch) -> Content
    
    var pitch: Pitch
    @ObservedObject var conductor: ViewConductor
    
    var zIndex: Int
    
    init(conductor: ViewConductor,
         pitch: Pitch,
         zIndex: Int = 0,
         @ViewBuilder pitchView: @escaping (Pitch) -> Content)
    {
        self.conductor = conductor
        self.pitch = pitch
        self.zIndex = zIndex
        self.pitchView = pitchView
    }
    
    func rect(rect: CGRect) -> some View {
        pitchView(pitch)
            .preference(key: PitchRectsKey.self,
                        value: [PitchRectInfo(rect: rect,
                                              pitch: pitch,
                                              zIndex: zIndex)])
    }
    
    public var body: some View {
        GeometryReader { proxy in
            rect(rect: proxy.frame(in: .global))
        }
    }
}
