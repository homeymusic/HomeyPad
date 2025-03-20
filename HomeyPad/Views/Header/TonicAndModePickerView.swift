import SwiftUI
import HomeyMusicKit

struct TonicAndModePickerView: View {
    
    @EnvironmentObject var notationalTonicContext: NotationalTonicContext
    
    var body: some View {
        if notationalTonicContext.showTonicPicker {
            VStack {
                TonicKeyboardView()
                .aspectRatio(13.0, contentMode: .fit)
                .transition(.scale(.leastNonzeroMagnitude, anchor: .bottom))
                
                if notationalTonicContext.showModes {
                    ModeKeyboardView()
                    .aspectRatio(13.0 * aspectMultiplier, contentMode: .fit)
                    .transition(.scale(.leastNonzeroMagnitude, anchor: .bottom))
                }
            }
            .padding(7.0)
            .background {
                RoundedRectangle(cornerRadius: 7.0)
                    .fill(Color(HomeyMusicKit.backgroundColor))
            }
        }
    }
    
    var aspectMultiplier: CGFloat {
        if notationalTonicContext.noteLabels[.tonicPicker]![.mode]! &&
           notationalTonicContext.noteLabels[.tonicPicker]![.guide]! {
            return HomeyMusicKit.goldenRatio
        } else {
            return 2.0
        }
    }
}
