import SwiftUI
import HomeyMusicKit

/// Touch-oriented musical keyboard
public struct InstrumentView<Content>: Identifiable, View where Content: View {
    @ObservedObject var conductor: ViewConductor
    
    @EnvironmentObject var instrumentContext: InstrumentContext
    
    public let id = UUID()
    
    public let pitchView: (Pitch) -> Content
    
    public var body: some View {
        ZStack {
            switch instrumentContext.instrumentType {
            case .isomorphic:
                IsomorphicView(
                    pitchView: pitchView,
                    viewConductor: conductor,
                    isomorphic: instrumentContext.instrument as! Isomorphic
                )
            case .zeena:
                ZeenaView(
                    pitchView: pitchView,
                    viewConductor: conductor,
                    zeena: instrumentContext.instrument as! Zeena
                )
            case .piano:
                PianoView(
                    pitchView: pitchView,
                    viewConductor: conductor,
                    piano: instrumentContext.instrument as! Piano
                )
            case .guitar:
                StringsView(
                    pitchView: pitchView,
                    viewConductor: conductor,
                    stringInstrument: instrumentContext.instrument as! Guitar
                )
            case .bass:
                StringsView(
                    pitchView: pitchView,
                    viewConductor: conductor,
                    stringInstrument: instrumentContext.instrument as! Bass
                )
            case .violin:
                StringsView(
                    pitchView: pitchView,
                    viewConductor: conductor,
                    stringInstrument: instrumentContext.instrument as! Violin
                )
            case .cello:
                StringsView(
                    pitchView: pitchView,
                    viewConductor: conductor,
                    stringInstrument: instrumentContext.instrument as! Cello
                )
            case .banjo:
                StringsView(
                    pitchView: pitchView,
                    viewConductor: conductor,
                    stringInstrument: instrumentContext.instrument as! Banjo
                )
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
