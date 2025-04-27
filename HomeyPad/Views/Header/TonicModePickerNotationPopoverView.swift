import SwiftUI
import HomeyMusicKit

struct TonicModePickerNotationPopoverView: View {
    @Environment(TonalContext.self) var tonalContext
    @Environment(NotationalTonicContext.self) var notationalTonicContext

    var body: some View {
        @Bindable var tonalContext = tonalContext
        VStack(spacing: 0.0) {
            Grid {
                if notationalTonicContext.showTonicPicker {
                    ForEach(IntervalLabelChoice.intervalClassCases, id: \.self) {key in
                        if key == .symbol {
                            Divider()
                        }
                        GridRow {
                            key.image
                                .gridCellAnchor(.center)
                                .foregroundColor(.white)
                            Toggle(key.label,
                                   isOn: notationalTonicContext.intervalBinding(for: .tonicPicker, choice: key))
                            .gridCellAnchor(.leading)
                            .tint(Color.gray)
                        }
                    }

                    Divider()

                    ForEach(PitchLabelChoice.pitchClassCases, id: \.self) {key in
                        if key != .accidentals {
                            GridRow {
                                key.image
                                    .gridCellAnchor(.center)
                                    .foregroundColor(.white)
                                Toggle(key.label,
                                       isOn: notationalTonicContext.noteBinding(for: .tonicPicker, choice: key))
                                .gridCellAnchor(.leading)
                                .tint(Color.gray)
                                .foregroundColor(.white)
                            }
                            if key == .letter {
                                GridRow {
                                    Image(systemName: PitchLabelChoice.accidentals.icon)
                                        .gridCellAnchor(.center)
                                    Picker("", selection: $tonalContext.accidental) {
                                        ForEach(Accidental.displayCases) { accidental in
                                            Text(accidental.icon)
                                                .tag(accidental as Accidental)
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                }
                            }
                        }
                    }
                }
                if notationalTonicContext.showTonicPicker && notationalTonicContext.showModePicker {
                    Divider()
                }
                if notationalTonicContext.showModePicker {
                    ForEach(PitchLabelChoice.modeCases, id: \.self) {key in
                        GridRow {
                            key.image
                                .gridCellAnchor(.center)
                                .foregroundColor(.white)
                            Toggle(key.label,
                                   isOn: notationalTonicContext.noteBinding(for: .tonicPicker, choice: key))
                            .gridCellAnchor(.leading)
                            .tint(Color.gray)
                            .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(10)
        }
    }
}
