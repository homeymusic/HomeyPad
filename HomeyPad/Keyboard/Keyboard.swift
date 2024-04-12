// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

/// Touch-oriented musical keyboard
public struct Keyboard<Content>: Identifiable, View where Content: View {
    @StateObject var conductor: ViewConductor
    @Binding var tonicMIDI: Int
    
    public let id = UUID()
    
    let keyboardKey: (Pitch) -> Content
    
    /// model  contains the keys, their status and touches
    @StateObject public var keyboardModel: KeyboardModel = KeyboardModel()
    
    public var body: some View {
        ZStack {
            switch conductor.layoutChoice {
            case .tonic:
                Tonic(keyboardKey: keyboardKey,
                      tonicKeyboardModel: TonicKeyboardModel(tonicMIDI: $tonicMIDI),
                      tonicConductor: conductor)
            case .isomorphic:
                Isomorphic(keyboardKey: keyboardKey,
                           keyboardModel: keyboardModel,
                           viewConductor: conductor)
            case .symmetric:
                Symmetric(keyboardKey: keyboardKey,
                          keyboardModel: keyboardModel,
                          viewConductor: conductor)
            case .piano:
                Piano(keyboardKey: keyboardKey,
                      keyboardModel: keyboardModel,
                      viewConductor: conductor,
                      spacer: PianoSpacer(viewConductor: conductor))
            case .strings:
                switch conductor.stringsLayoutChoice {
                case .guitar:
                    Strings(keyboardKey: keyboardKey,
                            keyboardModel: keyboardModel,
                            viewConductor: conductor)
                case .bass:
                    Strings(keyboardKey: keyboardKey,
                            keyboardModel: keyboardModel,
                            viewConductor: conductor)
                case .violin:
                    Strings(keyboardKey: keyboardKey,
                            keyboardModel: keyboardModel,
                            viewConductor: conductor)
                case .cello:
                    Strings(keyboardKey: keyboardKey,
                            keyboardModel: keyboardModel,
                            viewConductor: conductor)
                case .banjo:
                    Strings(keyboardKey: keyboardKey,
                            keyboardModel: keyboardModel,
                            viewConductor: conductor)
                }
            }
            
            if !conductor.latching {
                MultitouchView { touches in
                    keyboardModel.touchLocations = touches
                }
            }
            
        }.onPreferenceChange(KeyRectsKey.self) { keyRectInfos in
            keyboardModel.keyRectInfos = keyRectInfos
        }
    }
}
