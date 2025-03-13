import SwiftUI
import HomeyMusicKit

public struct ModeKeyboardView: Identifiable, View {
    @EnvironmentObject var instrumentalContext: InstrumentalContext
    @EnvironmentObject var tonalContext: TonalContext
    
    public let id = UUID()
    
    public var body: some View {
        ZStack {
            ModePickerView()            
            KeyboardKeyMultitouchView { touches in
                instrumentalContext.setModeLocations(
                    modeLocations: touches,
                    tonalContext: tonalContext
                )
            }            
        }.onPreferenceChange(ModeRectsKey.self) { modeRectInfos in
            instrumentalContext.modeRectInfos = modeRectInfos
        }
    }
}
