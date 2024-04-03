// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

/// Touch-oriented musical keyboard
public struct Keyboard<Content>: Identifiable, View where Content: View {
    public let id = UUID()
    
    let content: (Pitch, Pitch) -> Content
    
    /// model  contains the keys, their status and touches
    @StateObject public var model: KeyboardModel = .init()
    
    var tonicPitch: Pitch
    var layout: KeyboardLayout
    var latching: Bool
    
    /// Initialize the keyboard
    /// - Parameters:
    ///   - layout: The geometry of the keys
    ///   - latching: Latched keys stay on until they are pressed again
    ///   - content: View defining how to render a specific key
    public init(tonicPitch: Pitch,
                layout: KeyboardLayout,
                latching: Bool = false,
                @ViewBuilder content: @escaping (Pitch, Pitch) -> Content)
    {
        self.tonicPitch = tonicPitch
        self.layout = layout
        self.latching = latching
        self.content = content
    }
    
    /// Body enclosing the various layout views
    public var body: some View {
        ZStack {
            switch layout {
            case let .isomorphic(pitches, tonicPitch):
                Isomorphic(content: content,
                           model: model,
                           pitches: pitches,
                           tonicPitch: tonicPitch)
            case let .symmetric(pitches, tonicPitch):
                Symmetric(content: content,
                          model: model,
                          pitches: pitches,
                          tonicPitch: tonicPitch)
            case let .piano(pitches, tonicPitch, initialSpacerRatio, spacerRatio, relativeBlackKeyWidth, relativeBlackKeyHeight):
                Piano(content: content,
                      keyboard: model,
                      tonicPitch: tonicPitch,
                      spacer: PianoSpacer(pitches: pitches,
                                          tonicPitch: tonicPitch,
                                          initialSpacerRatio: initialSpacerRatio,
                                          spacerRatio: spacerRatio,
                                          relativeBlackKeyWidth: relativeBlackKeyWidth,
                                          relativeBlackKeyHeight: relativeBlackKeyHeight))
            case let .guitar(allPitches, tonicPitch, openStringsMIDI, fretCount):
                Guitar(content: content, model: model, allPitches: allPitches, tonicPitch: tonicPitch, openStringsMIDI: openStringsMIDI, fretCount: fretCount)
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
    init(tonicPitch: Pitch, layout: KeyboardLayout, latching: Bool)
    {
        self.tonicPitch = tonicPitch
        self.layout = layout
        self.latching = latching
        
        content = {
            KeyboardKey(
                pitch: $0,
                tonicPitch: $1
            )
        }
    }
}
