import SwiftUI
import HomeyMusicKit

/// Touch-oriented musical keyboard
public struct TonicKeyboardView: Identifiable, View {
    @ObservedObject var tonicConductor: ViewConductor
    
    public let id = UUID()
    
    public var body: some View {
        ZStack {
            TonicPickerView(
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
