import SwiftUI
import HomeyMusicKit

public enum ContainerType {
    case basic
    case diamond
    case span
    case tonicPicker
}

public struct PitchContainerView: View {
    var pitch: Pitch
    @ObservedObject var conductor: ViewConductor
    
    var zIndex: Int
    var pitchView: PitchView
    var containerType: ContainerType = .basic
    
    init(conductor: ViewConductor,
         pitch: Pitch,
         zIndex: Int = 0,
         containerType: ContainerType = .basic
    )
    {
        self.conductor = conductor
        self.pitch = pitch
        self.zIndex = zIndex
        self.containerType = containerType
        self.pitchView = PitchView(
            pitch: pitch,
            thisConductor: conductor,
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
