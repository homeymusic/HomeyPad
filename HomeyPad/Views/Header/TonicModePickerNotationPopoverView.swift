import SwiftUI
import HomeyMusicKit

struct TonicModePickerNotationPopoverView: View {
    @Environment(\.modelContext)            private var modelContext

    @Environment(AppContext.self) var appContext
    
    private var tonicPicker: TonicPicker {
        modelContext.singletonInstrument(for: .tonicPicker) as! TonicPicker
    }

    var body: some View {
        @Bindable var appContext = appContext
        VStack(spacing: 0.0) {
            Grid {
                if appContext.showTonicPicker {
                    ForEach(IntervalLabelType.intervalClassCases, id: \.self) {key in
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

                    ForEach(PitchLabelType.pitchClassCases, id: \.self) {key in
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
                                    Image(systemName: PitchLabelType.accidentals.icon)
                                        .gridCellAnchor(.center)
                                    Picker("", selection: Binding<Accidental>(
                                        get: { tonicPicker.tonality.accidental },
                                        set: { tonicPicker.tonality.accidental = $0 }
                                    )) {
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
                    ForEach(PitchLabelType.modeCases, id: \.self) {key in
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
    private func pitchBinding(for type: PitchLabelType) -> Binding<Bool> {
        Binding(
            get: {
                tonicPicker.pitchLabelTypes.contains(type)
            },
            set: { isOn in
                try? modelContext.transaction {
                    if isOn {
                        // inserting into a Set is idempotent
                        tonicPicker.pitchLabelTypes.insert(type)
                    } else {
                        tonicPicker.pitchLabelTypes.remove(type)
                    }
                }
            }
        )
    }
    
    private func intervalBinding(for type: IntervalLabelType) -> Binding<Bool> {
        Binding(
            get: {
                tonicPicker.intervalLabelTypes.contains(type)
            },
            set: { isOn in
                try? modelContext.transaction {
                    if isOn {
                        tonicPicker.intervalLabelTypes.insert(type)
                    } else {
                        tonicPicker.intervalLabelTypes.remove(type)
                    }
                }
            }
        )
    }
}
