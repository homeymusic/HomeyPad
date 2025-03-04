import SwiftUI
import HomeyMusicKit

/// Touch-oriented musical keyboard
public struct ModeKeyboardView<Content>: Identifiable, View where Content: View {
    @ObservedObject var modeConductor: ViewConductor
    @ObservedObject var tonalContext: TonalContext

    public let id = UUID()
    
    let modeView: (Mode, Int) -> Content
    
    public var body: some View {
        ZStack {
            ModePickerView(modeView: modeView,
                           modeConductor: modeConductor,
                           tonalContext: tonalContext)
            
            KeyboardKeyMultitouchView { touches in
                modeConductor.modeLocations = touches
            }
            
        }.onPreferenceChange(ModeRectsKey.self) { modeRectInfos in
            modeConductor.modeRectInfos = modeRectInfos
        }
    }
}
