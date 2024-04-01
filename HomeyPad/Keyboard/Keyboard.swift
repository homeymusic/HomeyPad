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
    var noteOn: (Pitch, CGPoint) -> Void
    var noteOff: (Pitch) -> Void

    /// Initialize the keyboard
    /// - Parameters:
    ///   - layout: The geometry of the keys
    ///   - latching: Latched keys stay on until they are pressed again
    ///   - noteOn: Closure to perform when a key is pressed
    ///   - noteOff: Closure to perform when a note ends
    ///   - content: View defining how to render a specific key
    public init(layout: KeyboardLayout = .piano(pitchRange: Pitch(60) ... Pitch(72)),
                latching: Bool = false,
                noteOn: @escaping (Pitch, CGPoint) -> Void = { _, _ in },
                noteOff: @escaping (Pitch) -> Void = { _ in },
                @ViewBuilder content: @escaping (Pitch, Bool) -> Content)
    {
        self.latching = latching
        self.layout = layout
        self.noteOn = noteOn
        self.noteOff = noteOff
        self.content = content
    }

    /// Body enclosing the various layout views
    public var body: some View {
        ZStack {
            switch layout {
            case let .isomorphic(pitchRange):
                Isomorphic(content: content,
                           model: model,
                           pitchRange: pitchRange)
            case let .symmetric(pitchRange):
                Symmetric(content: content,
                           model: model,
                           pitchRange: pitchRange)
            case let .piano(pitchRange, initialSpacerRatio, spacerRatio, relativeBlackKeyWidth, relativeBlackKeyHeight):
                Piano(content: content,
                      keyboard: model,
                      spacer: PianoSpacer(pitchRange: pitchRange,
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
        }.onAppear {
            model.noteOn = noteOn
            model.noteOff = noteOff
        }
    }
}

public extension Keyboard where Content == KeyboardKey {
    /// Initialize the Keyboard with KeyboardKey as its content
    /// - Parameters:
    ///   - layout: The geometry of the keys
    ///   - latching: Latched keys stay on until they are pressed again
    ///   - noteOn: Closure to perform when a key is pressed
    ///   - noteOff: Closure to perform when a note ends
    init(layout: KeyboardLayout = .piano(pitchRange: Pitch(60) ... Pitch(72)),
         latching: Bool = false,
         noteOn: @escaping (Pitch, CGPoint) -> Void = { _, _ in },
         noteOff: @escaping (Pitch) -> Void = { _ in })
    {
        self.layout = layout
        self.latching = latching
        self.noteOn = noteOn
        self.noteOff = noteOff

        var alignment: Alignment = .bottom

        var flatTop = false
        switch layout {
        case .isomorphic:
            alignment = .bottom
        case .symmetric:
            alignment = .bottom
        case .piano:
            flatTop = true
        case .guitar:
            alignment = .center
        }
        content = {
            KeyboardKey(
                pitch: $0,
                isActivated: $1
            )
        }
    }
}
