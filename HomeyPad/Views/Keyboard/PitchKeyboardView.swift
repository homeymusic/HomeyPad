import SwiftUI
import HomeyMusicKit

/// Touch-oriented musical keyboard
public struct PitchKeyboardView<Content>: Identifiable, View where Content: View {
    let instrument: Instrument
    @ObservedObject var conductor: ViewConductor
    @ObservedObject var tonalContext: TonalContext
    
    public let id = UUID()
    
    public let pitchView: (Pitch) -> Content
    
    public var body: some View {
        ZStack {
            switch conductor.layoutChoice {
            case .tonic:
                TonicPickerView(pitchView: pitchView,
                                tonicConductor: conductor,
                                tonalContext: tonalContext
                )
            case .isomorphic:
                IsomorphicView(pitchView: pitchView,
                               viewConductor: conductor,
                               tonalContext: tonalContext)
            case .symmetric:
                SymmetricView(pitchView: pitchView,
                              viewConductor: conductor,
                              tonalContext: tonalContext)
            case .piano:
                PianoView(pitchView: pitchView,
                          viewConductor: conductor,
                          tonalContext: tonalContext)
            case .strings:
                switch conductor.stringsLayoutChoice {
                case .guitar:
                    StringsView(pitchView: pitchView,
                                viewConductor: conductor,
                                tonalContext: tonalContext)
                case .bass:
                    StringsView(pitchView: pitchView,
                                viewConductor: conductor,
                                tonalContext: tonalContext)
                case .violin:
                    StringsView(pitchView: pitchView,
                                viewConductor: conductor,
                                tonalContext: tonalContext)
                case .cello:
                    StringsView(pitchView: pitchView,
                                viewConductor: conductor,
                                tonalContext: tonalContext)
                case .banjo:
                    StringsView(pitchView: pitchView,
                                viewConductor: conductor,
                                tonalContext: tonalContext)
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
