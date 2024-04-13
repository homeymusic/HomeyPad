// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

/// Touch-oriented musical keyboard
public struct Keyboard<Content>: Identifiable, View where Content: View {
    @StateObject var conductor: ViewConductor
        
    public let id = UUID()
    
    let keyboardKey: (Pitch) -> Content
    
    public var body: some View {
        ZStack {
            switch conductor.layoutChoice {
            case .tonic:
                Tonic(keyboardKey: keyboardKey,
                      tonicConductor: conductor)
            case .isomorphic:
                Isomorphic(keyboardKey: keyboardKey,
                           viewConductor: conductor)
            case .symmetric:
                Symmetric(keyboardKey: keyboardKey,
                          viewConductor: conductor)
            case .piano:
                Piano(keyboardKey: keyboardKey,
                      viewConductor: conductor,
                      spacer: PianoSpacer(viewConductor: conductor))
            case .strings:
                switch conductor.stringsLayoutChoice {
                case .guitar:
                    Strings(keyboardKey: keyboardKey,
                            viewConductor: conductor)
                case .bass:
                    Strings(keyboardKey: keyboardKey,
                            viewConductor: conductor)
                case .violin:
                    Strings(keyboardKey: keyboardKey,
                            viewConductor: conductor)
                case .cello:
                    Strings(keyboardKey: keyboardKey,
                            viewConductor: conductor)
                case .banjo:
                    Strings(keyboardKey: keyboardKey,
                            viewConductor: conductor)
                }
            }
            
            if !conductor.latching {
                MultitouchView { touches in
                    conductor.touchLocations = touches
                }
            }
            
        }.onPreferenceChange(KeyRectsKey.self) { keyRectInfos in
            conductor.keyRectInfos = keyRectInfos
        }
    }
}
