import SwiftUI
import HomeyMusicKit

/// Touch-oriented musical keyboard
public struct KeyboardView<Content>: Identifiable, View where Content: View {
    @ObservedObject var conductor: ViewConductor
        
    public let id = UUID()
    
    public let keyboardKeyView: (Pitch) -> Content
    
    public var body: some View {
        ZStack {
            switch conductor.layoutChoice {
            case .tonic:
                TonicPickerView(keyboardKeyView: keyboardKeyView,
                      tonicConductor: conductor)
            case .isomorphic:
                IsomorphicView(keyboardKeyView: keyboardKeyView,
                           viewConductor: conductor)
            case .symmetric:
                SymmetricView(keyboardKeyView: keyboardKeyView,
                          viewConductor: conductor)
            case .piano:
                PianoView(keyboardKeyView: keyboardKeyView,
                      viewConductor: conductor,
                      spacer: PianoSpacer(viewConductor: conductor))
            case .strings:
                switch conductor.stringsLayoutChoice {
                case .guitar:
                    StringsView(keyboardKeyView: keyboardKeyView,
                            viewConductor: conductor)
                case .bass:
                    StringsView(keyboardKeyView: keyboardKeyView,
                            viewConductor: conductor)
                case .violin:
                    StringsView(keyboardKeyView: keyboardKeyView,
                            viewConductor: conductor)
                case .cello:
                    StringsView(keyboardKeyView: keyboardKeyView,
                            viewConductor: conductor)
                case .banjo:
                    StringsView(keyboardKeyView: keyboardKeyView,
                            viewConductor: conductor)
                }
            }
            
            if !conductor.latching {
                KeyboardKeyMultitouchView { touches in
                    conductor.touchLocations = touches
                }
            }
            
        }.onPreferenceChange(KeyRectsKey.self) { keyRectInfos in
            conductor.keyRectInfos = keyRectInfos
        }
    }
}
