import SwiftUI
import HomeyMusicKit

/// Touch-oriented musical keyboard
public struct TonicKeyboardView: Identifiable, View {
    @ObservedObject var tonicConductor: ViewConductor
    
    @EnvironmentObject var instrumentalContext: InstrumentalContext
    @EnvironmentObject var tonalContext: TonalContext
    
    public let id = UUID()
    
    public var body: some View {
        ZStack {
            TonicPickerView()
            KeyboardKeyMultitouchView { touches in
                
                
                instrumentalContext.setPitchLocations(
                    pitchLocations: touches,
                    tonalContext: tonalContext
                )
            }
            .onPreferenceChange(PitchRectsKey.self) { keyRectInfos in
                instrumentalContext.pitchRectInfos = keyRectInfos
            }
        }
    }
} 
