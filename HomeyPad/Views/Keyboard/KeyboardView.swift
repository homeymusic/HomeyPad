import SwiftUI
import HomeyMusicKit

/// Touch-oriented musical keyboard
public struct KeyboardView<Content>: Identifiable, View where Content: View {
    @ObservedObject var conductor: ViewConductor
        
    public let id = UUID()
    
    public let keyboardKey: (Pitch) -> Content
    
    public var body: some View {
        ZStack {
            switch conductor.layoutChoice {
            case .tonic:
                TonicPickerView(keyboardKey: keyboardKey,
                      tonicConductor: conductor)
            case .isomorphic:
                IsomorphicView(keyboardKey: keyboardKey,
                           viewConductor: conductor)
            case .symmetric:
                SymmetricView(keyboardKey: keyboardKey,
                          viewConductor: conductor)
            case .piano:
                PianoView(keyboardKey: keyboardKey,
                      viewConductor: conductor,
                      spacer: PianoSpacer(viewConductor: conductor))
            case .strings:
                switch conductor.stringsLayoutChoice {
                case .guitar:
                    StringsView(keyboardKey: keyboardKey,
                            viewConductor: conductor)
                case .bass:
                    StringsView(keyboardKey: keyboardKey,
                            viewConductor: conductor)
                case .violin:
                    StringsView(keyboardKey: keyboardKey,
                            viewConductor: conductor)
                case .cello:
                    StringsView(keyboardKey: keyboardKey,
                            viewConductor: conductor)
                case .banjo:
                    StringsView(keyboardKey: keyboardKey,
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
