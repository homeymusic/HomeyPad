import SwiftUI
import HomeyMusicKit

/// Touch-oriented musical keyboard
public struct InstrumentView: Identifiable, View {
    @EnvironmentObject var instrumentalContext: InstrumentalContext
    @EnvironmentObject var tonalContext: TonalContext

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
                instrumentalContext.setPitchLocations(pitchLocations: touches, tonalContext: tonalContext)
            }
            
        }
        .onPreferenceChange(PitchRectsKey.self) { keyRectInfos in
            instrumentalContext.pitchRectInfos = keyRectInfos
        }
    }
}
