// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

/// Touch-oriented musical keyboard
public struct Keyboard<Content>: Identifiable, View where Content: View {
    @StateObject var viewConductor: ViewConductor
    
    public let id = UUID()
    
    let content: (Pitch) -> Content
    
    /// model  contains the keys, their status and touches
    @StateObject public var model: KeyboardModel = .init()
    
    public var body: some View {
        ZStack {
            switch viewConductor.layoutChoice {
            case .isomorphic:
                Isomorphic(content: content,
                           model: model,
                           viewConductor: viewConductor)
            case .tonic:
                Tonic(content: content,
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
            }
            
            if !viewConductor.latching {
                MultitouchView { touches in
                    model.touchLocations = touches
                }
            }
            
        }.onPreferenceChange(KeyRectsKey.self) { keyRectInfos in
            model.keyRectInfos = keyRectInfos
        }
    }
}
