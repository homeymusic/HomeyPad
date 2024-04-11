// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

/// Touch-oriented musical keyboard
public struct Keyboard<Content>: Identifiable, View where Content: View {
    @StateObject var viewConductor: ViewConductor
    
    public let id = UUID()
    
    let keyboardKey: (Pitch) -> Content
    
    /// model  contains the keys, their status and touches
    @StateObject public var keyboardModel: KeyboardModel = .init()
    
    public var body: some View {
        ZStack {
            switch viewConductor.layoutChoice {
            case .tonic:
                Tonic(keyboardKey: keyboardKey,
                      keyboardModel: keyboardModel,
                      tonicConductor: viewConductor)
            case .isomorphic:
                Isomorphic(keyboardKey: keyboardKey,
                           keyboardModel: keyboardModel,
                           viewConductor: viewConductor)
            case .symmetric:
                Symmetric(keyboardKey: keyboardKey,
                          keyboardModel: keyboardModel,
                          viewConductor: viewConductor)
            case .piano:
                Piano(keyboardKey: keyboardKey,
                      keyboardModel: keyboardModel,
                      viewConductor: viewConductor,
                      spacer: PianoSpacer(viewConductor: viewConductor))
            case .strings:
                switch viewConductor.stringsLayoutChoice {
                case .guitar:
                    Strings(keyboardKey: keyboardKey,
                            keyboardModel: keyboardModel,
                            viewConductor: viewConductor)
                case .bass:
                    Strings(keyboardKey: keyboardKey,
                            keyboardModel: keyboardModel,
                            viewConductor: viewConductor)
                case .violin:
                    Strings(keyboardKey: keyboardKey,
                            keyboardModel: keyboardModel,
                            viewConductor: viewConductor)
                case .cello:
                    Strings(keyboardKey: keyboardKey,
                            keyboardModel: keyboardModel,
                            viewConductor: viewConductor)
                }
            }
            
            if !viewConductor.latching {
                MultitouchView { touches in
                    keyboardModel.touchLocations = touches
                }
            }
            
        }.onPreferenceChange(KeyRectsKey.self) { keyRectInfos in
            keyboardModel.keyRectInfos = keyRectInfos
        }
    }
}
