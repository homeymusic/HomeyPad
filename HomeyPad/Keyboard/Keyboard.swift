import SwiftUI
import HomeyMusicKit

/// Touch-oriented musical keyboard
public struct Keyboard<Content>: Identifiable, View where Content: View {
    @ObservedObject var conductor: ViewConductor
        
    public let id = UUID()
    
    public let keyboardKey: (Pitch) -> Content
    
    public var body: some View {
        ZStack {
            switch conductor.layoutChoice {
            case .tonic:
                Tonic(keyboardKey: keyboardKey,
                      tonicConductor: conductor)
            case .isomorphic:
                Isomorphic(keyboardKey: keyboardKey,
                           viewConductor: conductor)
            case .dualistic:
                dualistic(keyboardKey: keyboardKey,
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
