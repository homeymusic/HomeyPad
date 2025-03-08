import SwiftUI
import HomeyMusicKit

/// Touch-oriented musical keyboard
public struct InstrumentView: Identifiable, View {
    @ObservedObject var conductor: ViewConductor
    
    @EnvironmentObject var instrumentContext: InstrumentContext
    
    public let id = UUID()
    
    public var body: some View {
        ZStack {
            switch instrumentContext.instrumentType {
            case .isomorphic:
                IsomorphicView(
                    viewConductor: conductor,
                    isomorphic: instrumentContext.instrument as! Isomorphic
                )
            case .zeena:
                ZeenaView(
                    viewConductor: conductor,
                    zeena: instrumentContext.instrument as! Zeena
                )
            case .piano:
                PianoView(
                    viewConductor: conductor,
                    piano: instrumentContext.instrument as! Piano
                )
            case .guitar:
                StringsView(
                    viewConductor: conductor,
                    stringInstrument: instrumentContext.instrument as! Guitar
                )
            case .bass:
                StringsView(
                    viewConductor: conductor,
                    stringInstrument: instrumentContext.instrument as! Bass
                )
            case .violin:
                StringsView(
                    viewConductor: conductor,
                    stringInstrument: instrumentContext.instrument as! Violin
                )
            case .cello:
                StringsView(
                    viewConductor: conductor,
                    stringInstrument: instrumentContext.instrument as! Cello
                )
            case .banjo:
                StringsView(
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
