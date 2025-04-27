import SwiftUI
import HomeyMusicKit

struct TonicModePickerNotationPopoverView: View {
    @Environment(\.modelContext)            private var modelContext

    @Environment(TonalContext.self) var tonalContext
    @Environment(AppContext.self) var appContext
    
    private var tonicPicker: TonicPicker {
        modelContext.instrument(for: .tonicPicker) as! TonicPicker
    }

    var body: some View {
        @Bindable var appContext = appContext
        @Bindable var tonalContext = tonalContext
        VStack(spacing: 0.0) {
            Grid {
                if appContext.showTonicPicker {
                    ForEach(IntervalLabelChoice.intervalClassCases, id: \.self) {key in
                        if key == .symbol {
                            Divider()
                        }
                        GridRow {
                            key.image
                                .gridCellAnchor(.center)
                                .foregroundColor(.white)
                            Toggle(key.label,
                                   isOn: intervalBinding(for: key))
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
                                       isOn: pitchBinding(for: key))
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
                if appContext.showTonicPicker && appContext.showModePicker {
                    Divider()
                }
                if appContext.showModePicker {
                    ForEach(PitchLabelChoice.modeCases, id: \.self) {key in
                        GridRow {
                            key.image
                                .gridCellAnchor(.center)
                                .foregroundColor(.white)
                            Toggle(key.label,
                                   isOn: pitchBinding(for: key))
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
    private func pitchBinding(for choice: PitchLabelChoice) -> Binding<Bool> {
        Binding(
            get: {
                tonicPicker.pitchLabelChoices.contains(choice)
            },
            set: { isOn in
                try? modelContext.transaction {
                    if isOn {
                        // inserting into a Set is idempotent
                        tonicPicker.pitchLabelChoices.insert(choice)
                    } else {
                        tonicPicker.pitchLabelChoices.remove(choice)
                    }
                }
            }
        )
    }
    
    private func intervalBinding(for choice: IntervalLabelChoice) -> Binding<Bool> {
        Binding(
            get: {
                tonicPicker.intervalLabelChoices.contains(choice)
            },
            set: { isOn in
                try? modelContext.transaction {
                    if isOn {
                        tonicPicker.intervalLabelChoices.insert(choice)
                    } else {
                        tonicPicker.intervalLabelChoices.remove(choice)
                    }
                }
            }
        )
    }
}
