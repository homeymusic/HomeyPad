import SwiftUI
import HomeyMusicKit

struct TonicAndModePickerView: View {
    
    @Environment(NotationalTonicContext.self) var notationalTonicContext
    
    var body: some View {
        VStack(spacing: 5) {
            if notationalTonicContext.showTonicPicker {
                TonicKeyboardView()
                    .aspectRatio(13.0, contentMode: .fit)
                    .transition(.scale(.leastNonzeroMagnitude, anchor: .bottom))
            }
            
            if notationalTonicContext.showModePicker {
                ModeKeyboardView()
                    .aspectRatio(13.0 * aspectMultiplier, contentMode: .fit)
                    .transition(.scale(.leastNonzeroMagnitude, anchor: .bottom))
            }
        }
    }
    
    var aspectMultiplier: CGFloat {
        if notationalTonicContext.noteLabels[.tonicPicker]![.mode]! &&
            notationalTonicContext.noteLabels[.tonicPicker]![.guide]! {
            return 1.0
        } else {
            return 2.0
        }
    }
}
