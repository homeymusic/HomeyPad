import SwiftUI
import HomeyMusicKit

/// Touch-oriented musical keyboard
public struct ModeKeyboardView: Identifiable, View {
    @ObservedObject var modeConductor: ViewConductor

    public let id = UUID()
    
    public var body: some View {
        ZStack {
            ModePickerView(
                modeConductor: modeConductor
            )            
            KeyboardKeyMultitouchView { touches in
                modeConductor.modeLocations = touches
            }
            
        }.onPreferenceChange(ModeRectsKey.self) { modeRectInfos in
            modeConductor.modeRectInfos = modeRectInfos
        }
    }
}
