import SwiftUI
import SwiftData
import HomeyMusicKit

struct NotationPopoverView: View {
    @Environment(\.modelContext)            private var modelContext
    @Environment(AppContext.self)  private var appContext
    
    private var instrument: any Instrument {
        modelContext.singletonInstrument(for: appContext.instrumentType)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Grid {
                // — INTERVAL LABELS —
                ForEach(IntervalLabelType.allCases, id: \.self) { type in
                    if type == .symbol {
                        Divider()
                    }
                    GridRow {
                        type.image
                            .gridCellAnchor(.center)
                            .foregroundColor(.white)
                        Toggle(type.label, isOn: intervalBinding(for: type))
                            .gridCellAnchor(.leading)
                            .tint(.gray)
                    }
                }
                
                Divider()
                
                // — PITCH LABELS —
                ForEach(PitchLabelType.pitchCases, id: \.self) { type in
                    // skip any special ones if you like
                    if type != .accidentals {
                        GridRow {
                            type.image
                                .gridCellAnchor(.center)
                                .foregroundColor(.white)
                            Toggle(type.label, isOn: pitchBinding(for: type))
                                .gridCellAnchor(.leading)
                                .tint(.gray)
                        }
                        
                        // if you need the “fixed Do” submenu
                        if type == .fixedDo {
                            // Accidentals‐picker
                            GridRow {
                                type.image
                                    .gridCellAnchor(.center)
                                    .foregroundColor(.white)
                                Picker("", selection: Binding<Accidental>(
                                    get: { instrument.tonality.accidental },
                                    set: { instrument.tonality.accidental = $0 }
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
    
    private func pitchBinding(for type: PitchLabelType) -> Binding<Bool> {
        Binding(
            get: {
                instrument.pitchLabelTypes.contains(type)
            },
            set: { isOn in
                try? modelContext.transaction {
                    if isOn {
                        // inserting into a Set is idempotent
                        instrument.pitchLabelTypes.insert(type)
                    } else {
                        instrument.pitchLabelTypes.remove(type)
                    }
                }
            }
        )
    }
    
    private func intervalBinding(for type: IntervalLabelType) -> Binding<Bool> {
        Binding(
            get: {
                instrument.intervalLabelTypes.contains(type)
            },
            set: { isOn in
                try? modelContext.transaction {
                    if isOn {
                        instrument.intervalLabelTypes.insert(type)
                    } else {
                        instrument.intervalLabelTypes.remove(type)
                    }
                }
            }
        )
    }
}
