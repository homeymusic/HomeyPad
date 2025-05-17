import SwiftUI
import HomeyMusicKit

struct TonicModePickerNotationPopoverView: View {
    @Environment(\.modelContext)            private var modelContext
    @Environment(AppContext.self) var appContext
    
    @Bindable public var tonalityInstrument: TonalityInstrument

    var body: some View {
        @Bindable var appContext = appContext
        VStack(spacing: 0.0) {
            Grid {
                if tonalityInstrument.showTonicPicker {
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
                                        get: { tonalityInstrument.accidental },
                                        set: { tonalityInstrument.accidental = $0 }
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
                if tonalityInstrument.showTonicPicker && tonalityInstrument.showModePicker {
                    Divider()
                }
                if tonalityInstrument.showModePicker {
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
    private func pitchBinding(for pitchLabelType: PitchLabelType) -> Binding<Bool> {
        Binding(
            get: {
                tonalityInstrument.pitchLabelTypes.contains(pitchLabelType)
            },
            set: { isOn in
                try? modelContext.transaction {
                    if isOn {
                        // inserting into a Set is idempotent
                        tonalityInstrument.pitchLabelTypes.insert(pitchLabelType)
                    } else {
                        tonalityInstrument.pitchLabelTypes.remove(pitchLabelType)
                    }
                }
            }
        )
    }
    
    private func intervalBinding(for intervalLabelType: IntervalLabelType) -> Binding<Bool> {
        Binding(
            get: {
                tonalityInstrument.intervalLabelTypes.contains(intervalLabelType)
            },
            set: { isOn in
                try? modelContext.transaction {
                    if isOn {
                        tonalityInstrument.intervalLabelTypes.insert(intervalLabelType)
                    } else {
                        tonalityInstrument.intervalLabelTypes.remove(intervalLabelType)
                    }
                }
            }
        )
    }
}
