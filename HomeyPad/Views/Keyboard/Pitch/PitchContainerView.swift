//PitchView(
//    pitch: pitch,
//    thisConductor: tonicConductor,
//    tonicConductor: tonicConductor,
//    viewConductor: viewConductor,
//    modeConductor: modeConductor
//)
//.aspectRatio(1.0, contentMode: .fit)



import SwiftUI
import HomeyMusicKit

/// This handles the interaction for key, so the user can provide their own
/// visual representation.
public struct PitchContainerView: View {
    var pitch: Pitch
    @ObservedObject var conductor: ViewConductor
    
    var zIndex: Int
    var pitchView: PitchView
    
    init(conductor: ViewConductor,
         pitch: Pitch,
         zIndex: Int = 0)
    {
        self.conductor = conductor
        self.pitch = pitch
        self.zIndex = zIndex
        self.pitchView = PitchView(pitch: pitch, thisConductor: conductor)
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
