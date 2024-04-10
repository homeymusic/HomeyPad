// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

/// Touch-oriented musical keyboard
public struct Keyboard<Content>: Identifiable, View where Content: View {
    public let id = UUID()
    
    let content: (Pitch) -> Content
    
    /// model  contains the keys, their status and touches
    public var model: KeyboardModel = .init()

    var viewConductor: ViewConductor
    
    init(viewConductor: ViewConductor,
         @ViewBuilder content: @escaping (Pitch) -> Content)
    {
        self.viewConductor = viewConductor
        self.content = content
    }
    
    /// Body enclosing the various layout views
    public var body: some View {
        ZStack {
            switch viewConductor.layoutChoice {
            case .isomorphic:
                Isomorphic(content: content,
                           model: model,
                           viewConductor: viewConductor)
            case .symmetric:
                Symmetric(content: content,
                          model: model,
                          viewConductor: viewConductor)
            case .piano:
                Piano(content: content,
                      model: model,
                      viewConductor: viewConductor,
                      spacer: PianoSpacer(viewConductor: viewConductor))
            case .strings:
                switch viewConductor.stringsLayoutChoice {
                case .guitar:
                    Strings(content: content,
                            model: model,
                            viewConductor: viewConductor)
                case .bass:
                    Strings(content: content,
                            model: model,
                            viewConductor: viewConductor)
                case .violin:
                    Strings(content: content,
                            model: model,
                            viewConductor: viewConductor)
                case .cello:
                    Strings(content: content,
                            model: model,
                            viewConductor: viewConductor)
                }
                                        
            default:
                Color.clear
            }
            
            if !viewConductor.latching {
                MultitouchView { touches in
                    model.touchLocations = touches
                }
            }
            
        }.onPreferenceChange(KeyRectsKey.self) { keyRectInfos in
            print("onPreferenceChange")
            model.keyRectInfos = keyRectInfos
        }
    }
}

public extension Keyboard where Content == KeyboardKey {
    internal init(viewConductor: ViewConductor)
    {
        self.viewConductor = viewConductor
        content = {
            KeyboardKey(
                pitch: $0,
                viewConductor: viewConductor
            )
        }
    }
}
