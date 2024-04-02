// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

/// Touch-oriented musical keyboard
public struct Keyboard<Content>: Identifiable, View where Content: View {
    public let id = UUID()
    
    let content: (Pitch, Bool) -> Content
    
    /// model  contains the keys, their status and touches
    @StateObject public var model: KeyboardModel = .init()
    
    var layout: KeyboardLayout
    var latching: Bool
    
    /// Initialize the keyboard
    /// - Parameters:
    ///   - layout: The geometry of the keys
    ///   - latching: Latched keys stay on until they are pressed again
    ///   - content: View defining how to render a specific key
    public init(layout: KeyboardLayout,
                latching: Bool = false,
                @ViewBuilder content: @escaping (Pitch, Bool) -> Content)
    {
        self.latching = latching
        self.layout = layout
        self.content = content
    }
    
    /// Body enclosing the various layout views
    public var body: some View {
        ZStack {
            switch layout {
            case let .isomorphic(pitches):
                Isomorphic(content: content,
                           model: model,
                           pitches: pitches)
            case let .symmetric(pitches):
                Symmetric(content: content,
                          model: model,
                          pitches: pitches)
            case let .piano(pitches, initialSpacerRatio, spacerRatio, relativeBlackKeyWidth, relativeBlackKeyHeight):
                Piano(content: content,
                      keyboard: model,
                      spacer: PianoSpacer(pitches: pitches,
                                          initialSpacerRatio: initialSpacerRatio,
                                          spacerRatio: spacerRatio,
                                          relativeBlackKeyWidth: relativeBlackKeyWidth,
                                          relativeBlackKeyHeight: relativeBlackKeyHeight))
            case let .guitar(openPitches, fretCount):
                Guitar(content: content, model: model, openPitches: openPitches, fretCount: fretCount)
            }
            
            if !latching {
                MultitouchView { touches in
                    model.touchLocations = touches
                }
            }
            
        }.onPreferenceChange(KeyRectsKey.self) { keyRectInfos in
            model.keyRectInfos = keyRectInfos
        }
    }
}

public extension Keyboard where Content == KeyboardKey {
    /// Initialize the Keyboard with KeyboardKey as its content
    /// - Parameters:
    ///   - layout: The geometry of the keys
    ///   - latching: Latched keys stay on until they are pressed again
    init(layout: KeyboardLayout, latching: Bool)
    {
        self.layout = layout
        self.latching = latching
        
        content = {
            KeyboardKey(
                pitch: $0,
                isActivated: $1
            )
        }
    }
}
