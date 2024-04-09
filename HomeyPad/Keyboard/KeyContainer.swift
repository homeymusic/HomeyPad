// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

/// This handles the interaction for key, so the user can provide their own
/// visual representation.
public struct KeyContainer<Content: View>: View {
    let content: (Pitch) -> Content

    var pitch: Pitch
    var tonicPitch: Pitch
    @ObservedObject var model: KeyboardModel

    var zIndex: Int

    /// Initialize the Container
    /// - Parameters:
    ///   - model: KeyboardModel holding all the keys
    ///   - pitch: Pitch of this key
    ///   - zIndex: Layering in z-axis
    ///   - content: View defining how to render a specific key
    init(model: KeyboardModel,
         pitch: Pitch,
         tonicPitch: Pitch,
         zIndex: Int = 0,
         @ViewBuilder content: @escaping (Pitch) -> Content)
    {
        self.model = model
        self.pitch = pitch
        self.tonicPitch = tonicPitch
        self.zIndex = zIndex
        self.content = content
    }

    func rect(rect: CGRect) -> some View {
        content(pitch)
            .contentShape(Rectangle()) // Added to improve tap/click reliability
            .gesture(
                TapGesture().onEnded { _ in
                    if model.externallyActivatedPitches.contains(pitch) {
                        model.externallyActivatedPitches.remove(pitch)
                    } else {
                        model.externallyActivatedPitches.insert(pitch)
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
