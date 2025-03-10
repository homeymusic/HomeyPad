import SwiftUI
import HomeyMusicKit

struct TonicAndModePickerView: View {
    
    @ObservedObject var tonicConductor: ViewConductor
    @ObservedObject var modeConductor: ViewConductor
    
    @EnvironmentObject var notationalTonicContext: NotationalTonicContext

    var body: some View {
        VStack {
            TonicKeyboardView(
                tonicConductor: tonicConductor
            )
            .aspectRatio(13.0, contentMode: .fit)
            .transition(.scale(.leastNonzeroMagnitude, anchor: .bottom))
            
            if notationalTonicContext.showModes {
                ModeKeyboardView(
                    modeConductor: modeConductor
                )
                .aspectRatio(13.0 * 2.0, contentMode: .fit)
                .transition(.scale(.leastNonzeroMagnitude, anchor: .bottom))
            }
            
        }
        .padding(7.0)
        .background {
            RoundedRectangle(cornerRadius: 7.0)
                .fill(Color(UIColor.systemGray6))
        }
    }
}
