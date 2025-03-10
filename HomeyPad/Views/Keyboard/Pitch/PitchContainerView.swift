import SwiftUI
import HomeyMusicKit

public struct PitchContainerView: View {
    var pitch: Pitch
    
    var zIndex: Int
    var pitchView: PitchView
    var containerType: ContainerType = .basic
    
    init(pitch: Pitch,
         zIndex: Int = 0,
         containerType: ContainerType = .basic
    )
    {
        self.pitch = pitch
        self.zIndex = zIndex
        self.containerType = containerType
        self.pitchView = PitchView(
            pitch: pitch,
            containerType: containerType
        )
    }
    
    func rect(rect: CGRect) -> some View {
        pitchView
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
