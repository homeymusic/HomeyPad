// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

/// This handles the interaction for key, so the user can provide their own
/// visual representation.
public struct KeyContainer<Content: View>: View {
    let keyboardKey: (Pitch) -> Content

    var pitch: Pitch
    var conductor: ViewConductor
    @ObservedObject var keyboardModel: KeyboardModel

    var tonicPitch: Pitch
    var zIndex: Int
    
    /// Initialize the Container
    /// - Parameters:
    ///   - model: KeyboardModel holding all the keys
    ///   - pitch: Pitch of this key
    ///   - zIndex: Layering in z-axis
    ///   - content: View defining how to render a specific key
    init(keyboardModel: KeyboardModel,
         pitch: Pitch,
         conductor: ViewConductor,
         zIndex: Int = 0,
         @ViewBuilder keyboardKey: @escaping (Pitch) -> Content)
    {
        self.keyboardModel = keyboardModel
        self.pitch = pitch
        self.conductor = conductor
        self.tonicPitch = conductor.tonicPitch
        self.zIndex = zIndex
        self.keyboardKey = keyboardKey
    }

    func rect(rect: CGRect) -> some View {
        keyboardKey(pitch)
            .contentShape(Rectangle()) // Added to improve tap/click reliability
            .gesture(
                TapGesture().onEnded { _ in
                    if keyboardModel.externallyActivatedPitches.contains(pitch) {
                        keyboardModel.externallyActivatedPitches.remove(pitch)
                    } else {
                        keyboardModel.externallyActivatedPitches.insert(pitch)
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
