import SwiftUI
import HomeyMusicKit

/// This handles the interaction for key, so the user can provide their own
/// visual representation.
public struct KeyboardKeyContainerView<Content: View>: View {
    let keyboardKey: (Pitch) -> Content

    var pitch: Pitch
    @ObservedObject var conductor: ViewConductor
    
    var zIndex: Int
    
    init(conductor: ViewConductor,
         pitch: Pitch,
         zIndex: Int = 0,
         @ViewBuilder keyboardKey: @escaping (Pitch) -> Content)
    {
        self.conductor = conductor
        self.pitch = pitch
        self.zIndex = zIndex
        self.keyboardKey = keyboardKey
    }

    func rect(rect: CGRect) -> some View {
        keyboardKey(pitch)
            .contentShape(Rectangle()) // Added to improve tap/click reliability
            .gesture(
                TapGesture().onEnded { _ in
                    if (conductor.latching) {
                        if conductor.externallyActivatedPitches.contains(pitch) {
                            conductor.externallyActivatedPitches.remove(pitch)
                        } else { 
                            conductor.externallyActivatedPitches.insert(pitch)
                        }
                    }
                }
            )
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
