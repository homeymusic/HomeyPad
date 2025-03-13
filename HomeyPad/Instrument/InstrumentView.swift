import SwiftUI
import HomeyMusicKit

/// Touch-oriented musical keyboard
public struct InstrumentView: Identifiable, View {
    @ObservedObject var conductor: ViewConductor
    
    @EnvironmentObject var instrumentalContext: InstrumentalContext
    
    public let id = UUID()
    
    public var body: some View {
        ZStack {
            switch instrumentalContext.instrumentType {
            case .isomorphic:
                IsomorphicView(
                    isomorphic: instrumentalContext.instrument as! Isomorphic
                )
            case .tonnetz:
                TonnetzView(
                    tonnetz: instrumentalContext.instrument as! Tonnetz
                )
            case .diamanti:
                DiamantiView(
                    diamanti: instrumentalContext.instrument as! Diamanti
                )
            case .piano:
                PianoView(
                    piano: instrumentalContext.instrument as! Piano
                )
            case .guitar:
                StringsView(
                    stringInstrument: instrumentalContext.instrument as! Guitar
                )
            case .bass:
                StringsView(
                    stringInstrument: instrumentalContext.instrument as! Bass
                )
            case .violin:
                StringsView(
                    stringInstrument: instrumentalContext.instrument as! Violin
                )
            case .cello:
                StringsView(
                    stringInstrument: instrumentalContext.instrument as! Cello
                )
            case .banjo:
                StringsView(
                    stringInstrument: instrumentalContext.instrument as! Banjo
                )
            default:
                EmptyView()
            }
            
            KeyboardKeyMultitouchView { touches in
                // TODO: add a fn to InstrumentalContext:
                // instrumentalContext.setPitchLocations(touches, tonalContext, synthConductor)
                // and move the ViewConductor capability to there.
                conductor.pitchLocations = touches
            }
            
        }
        .onPreferenceChange(PitchRectsKey.self) { keyRectInfos in
            conductor.pitchRectInfos = keyRectInfos
        }
    }
}
