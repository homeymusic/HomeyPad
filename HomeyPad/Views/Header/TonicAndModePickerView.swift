import SwiftUI
import HomeyMusicKit

struct TonicAndModePickerView: View {
    @Environment(NotationalTonicContext.self) var notationalTonicContext
    let horizontalCellCount = 13.0

    var body: some View {
        if isModeOrTonicPickersShown {
            HStack(spacing: 5) {
                ZStack {
                    Rectangle()
                        .fill(areModeAndTonicPickersShown ? .white : .clear)
                        .frame(width: 1)
                    
                    Image(systemName: "personalhotspot")
                        .aspectRatio(1.0, contentMode: .fit)
                        .foregroundColor(areModeAndTonicPickersShown ? .white : .clear)
                }
                
                VStack(spacing: 5) {
                    if notationalTonicContext.showTonicPicker {
                        TonicInstrumentView()
                            .aspectRatio(horizontalCellCount, contentMode: .fit)
                    }
                    if notationalTonicContext.showModePicker {
                        ModeInstrumentView()
                            .aspectRatio(horizontalCellCount * aspectMultiplier, contentMode: .fit)
                    }
                }
                
                
                ZStack {
                    Rectangle()
                        .fill(areModeAndTonicPickersShown ? .white : .clear)
                        .frame(width: 1)
                    
                    Image(systemName: "personalhotspot")
                        .aspectRatio(1.0, contentMode: .fit)
                        .foregroundColor(areModeAndTonicPickersShown ? .white : .clear)
                }
            }
            // Lock the entire TonicAndModePickerView to the ratio we computed
            .aspectRatio(ratio, contentMode: .fit)
        } else {
            EmptyView()
        }
    }
    
    var ratio : CGFloat {
        if areModeAndTonicPickersShown {
            return horizontalCellCount / (areBothModeNoteLabelsShown ? 2.0 : 1.5)
        } else if notationalTonicContext.showModePicker {
            return horizontalCellCount  * aspectMultiplier
        } else {
            return horizontalCellCount
        }
    }
    
    var areModeAndTonicPickersShown: Bool {
        notationalTonicContext.showModePicker &&
        notationalTonicContext.showTonicPicker
    }
    
    var isModeOrTonicPickersShown: Bool {
        notationalTonicContext.showModePicker ||
        notationalTonicContext.showTonicPicker
    }
    
    var areBothModeNoteLabelsShown: Bool {
        notationalTonicContext.noteLabels[.tonicPicker]![.mode]! &&
        notationalTonicContext.noteLabels[.tonicPicker]![.map]!
    }
    /// Example multiplier used for the Mode instrument's aspect ratio
    var aspectMultiplier: CGFloat {
        // For example, if certain label combos are visible,
        // you might want the ModeInstrumentView to be "double height"
        // or "the same height" etc.
        if areBothModeNoteLabelsShown {
            return 1.0
        } else {
            return 2.0
        }
    }
}
