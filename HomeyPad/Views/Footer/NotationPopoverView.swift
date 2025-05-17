import SwiftUI
import SwiftData
import HomeyMusicKit

struct NotationPopoverView: View {
    @Environment(\.modelContext)            private var modelContext
    @Environment(AppContext.self)  private var appContext
    
    @Environment(SynthConductor.self) private var synthConductor
    @Environment(MIDIConductor.self)  private var midiConductor

    private var musicalInstrument: MusicalInstrument {
        modelContext.singletonInstrument(
            for: appContext.instrumentType,
            midiConductor: midiConductor,
            synthConductor: synthConductor
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            Grid {
                // — INTERVAL LABELS —
                ForEach(IntervalLabelType.allCases, id: \.self) { intervalLabelType in
                    if intervalLabelType == .symbol {
                        Divider()
                    }
                    GridRow {
                        intervalLabelType.image
                            .gridCellAnchor(.center)
                            .foregroundColor(.white)
                        Toggle(intervalLabelType.label, isOn: intervalBinding(for: intervalLabelType))
                            .gridCellAnchor(.leading)
                            .tint(.gray)
                    }
                }
                
                Divider()
                
                // — PITCH LABELS —
                ForEach(PitchLabelType.pitchCases, id: \.self) { pitchLabelType in
                    // skip any special ones if you like
                    if pitchLabelType != .accidentals {
                        GridRow {
                            pitchLabelType.image
                                .gridCellAnchor(.center)
                                .foregroundColor(.white)
                            Toggle(pitchLabelType.label, isOn: pitchBinding(for: pitchLabelType))
                                .gridCellAnchor(.leading)
                                .tint(.gray)
                        }
                        
                        // if you need the “fixed Do” submenu
                        if pitchLabelType == .fixedDo {
                            // Accidentals‐picker
                            GridRow {
                                pitchLabelType.image
                                    .gridCellAnchor(.center)
                                    .foregroundColor(.white)
                                Picker("", selection: Binding<Accidental>(
                                    get: { musicalInstrument.accidental },
                                    set: { musicalInstrument.accidental = $0 }
                                )) {
                                    ForEach(Accidental.displayCases) { acc in
                                        Text(acc.icon)
                                            .tag(acc)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                    }
                }
            }
            .padding(10)
        }
    }
    
    // MARK: – Helpers to bind each type to its array membership
    
    private func pitchBinding(for pitchLabelType: PitchLabelType) -> Binding<Bool> {
        Binding(
            get: {
                musicalInstrument.pitchLabelTypes.contains(pitchLabelType)
            },
            set: { isOn in
                try? modelContext.transaction {
                    if isOn {
                        // inserting into a Set is idempotent
                        musicalInstrument.pitchLabelTypes.insert(pitchLabelType)
                    } else {
                        musicalInstrument.pitchLabelTypes.remove(pitchLabelType)
                    }
                }
            }
        )
    }
    
    private func intervalBinding(for intervalLabelType: IntervalLabelType) -> Binding<Bool> {
        Binding(
            get: {
                musicalInstrument.intervalLabelTypes.contains(intervalLabelType)
            },
            set: { isOn in
                try? modelContext.transaction {
                    if isOn {
                        musicalInstrument.intervalLabelTypes.insert(intervalLabelType)
                    } else {
                        musicalInstrument.intervalLabelTypes.remove(intervalLabelType)
                    }
                }
            }
        )
    }
}
