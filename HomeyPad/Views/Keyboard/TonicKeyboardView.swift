import SwiftUI
import HomeyMusicKit

/// Touch-oriented musical keyboard
public struct TonicKeyboardView<Content>: Identifiable, View where Content: View {
    @ObservedObject var tonicConductor: ViewConductor
    
    public let id = UUID()
    
    public let pitchView: (Pitch) -> Content
    
    public var body: some View {
        ZStack {
                TonicPickerView(
                    pitchView: pitchView,
                    tonicConductor: tonicConductor
                )
            KeyboardKeyMultitouchView { touches in
                tonicConductor.pitchLocations = touches
            }
            
        }
        .onPreferenceChange(PitchRectsKey.self) { keyRectInfos in
            tonicConductor.pitchRectInfos = keyRectInfos
        }
    }
}
