import SwiftUI
import HomeyMusicKit

/// Touch-oriented musical keyboard
public struct ModeKeyboardView<Content>: Identifiable, View where Content: View {
    @ObservedObject var conductor: ViewConductor
    
    public let id = UUID()
    
    public let modeView: (Mode) -> Content
    
    public var body: some View {
        ZStack {
            ModePickerView(modeView: modeView,
                           modeConductor: conductor)
            
            KeyboardKeyMultitouchView { touches in
                conductor.touchLocations = touches
            }
            
        }.onPreferenceChange(ModeRectsKey.self) { modeRectInfos in
            Task { @MainActor in
                conductor.modeRectInfos = modeRectInfos
            }
        }
    }
}
