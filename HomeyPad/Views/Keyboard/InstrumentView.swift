import SwiftUI
import HomeyMusicKit

/// Touch-oriented musical keyboard
public struct InstrumentView<Content>: Identifiable, View where Content: View {
    let instrument: Instrument
    @ObservedObject var conductor: ViewConductor
    
    public let id = UUID()
    
    public let pitchView: (Pitch) -> Content
    
    public var body: some View {
        ZStack {
            switch conductor.layoutChoice {
            case .tonic:
                TonicPickerView(
                    pitchView: pitchView,
                    tonicConductor: conductor
                )
            case .isomorphic:
                IsomorphicView(pitchView: pitchView,
                               viewConductor: conductor)
            case .symmetric:
                SymmetricView(pitchView: pitchView,
                              viewConductor: conductor)
            case .piano:
                PianoView(pitchView: pitchView,
                          viewConductor: conductor)
            case .strings:
                switch conductor.stringsLayoutChoice {
                case .guitar:
                    StringsView(pitchView: pitchView,
                                viewConductor: conductor)
                case .bass:
                    StringsView(pitchView: pitchView,
                                viewConductor: conductor)
                case .violin:
                    StringsView(pitchView: pitchView,
                                viewConductor: conductor)
                case .cello:
                    StringsView(pitchView: pitchView,
                                viewConductor: conductor)
                case .banjo:
                    StringsView(pitchView: pitchView,
                                viewConductor: conductor)
                }
            case .mode:
                EmptyView()
            }
            
            KeyboardKeyMultitouchView { touches in
                conductor.pitchLocations = touches
            }
            
        }
        .onPreferenceChange(PitchRectsKey.self) { keyRectInfos in
            conductor.pitchRectInfos = keyRectInfos
        }
    }
}
