import SwiftUI
import HomeyMusicKit

struct TonicAndModePickerView: View {
    
    @ObservedObject var tonicConductor: ViewConductor
    @ObservedObject var modeConductor: ViewConductor
    
    @EnvironmentObject var notationalTonicContext: NotationalTonicContext
    
    var body: some View {
        if notationalTonicContext.showTonicPicker {
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
                    .aspectRatio(13.0 * aspectMultiplier, contentMode: .fit)
                    .transition(.scale(.leastNonzeroMagnitude, anchor: .bottom))
                }
            }
            .padding(7.0)
            .background {
                RoundedRectangle(cornerRadius: 7.0)
                    .fill(.black)
            }
        }
    }
    
    var aspectMultiplier: CGFloat {
        if notationalTonicContext.noteLabels[.tonicPicker]![.mode]! &&
           notationalTonicContext.noteLabels[.tonicPicker]![.guide]! {
            return HomeyPad.goldenRatio
        } else {
            return 2.0
        }
    }
}
