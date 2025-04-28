import SwiftUI
import SwiftData
import HomeyMusicKit

struct NotationPopoverView: View {
    @Environment(\.modelContext)            private var modelContext
    @Environment(InstrumentalContext.self)  private var instrumentalContext
    
    private var instrument: any Instrument {
        modelContext.instrument(for: instrumentalContext.instrumentChoice)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Grid {
                // — INTERVAL LABELS —
                ForEach(IntervalLabelChoice.allCases, id: \.self) { choice in
                    if choice == .symbol {
                        Divider()
                    }
                    GridRow {
                        choice.image
                            .gridCellAnchor(.center)
                            .foregroundColor(.white)
                        Toggle(choice.label, isOn: intervalBinding(for: choice))
                            .gridCellAnchor(.leading)
                            .tint(.gray)
                    }
                }
                
                Divider()
                
                // — PITCH LABELS —
                ForEach(PitchLabelChoice.pitchCases, id: \.self) { choice in
                    // skip any special ones if you like
                    if choice != .accidentals {
                        GridRow {
                            choice.image
                                .gridCellAnchor(.center)
                                .foregroundColor(.white)
                            Toggle(choice.label, isOn: pitchBinding(for: choice))
                                .gridCellAnchor(.leading)
                                .tint(.gray)
                        }
                        
                        // if you need the “fixed Do” submenu
                        if choice == .fixedDo {
                            // Accidentals‐picker
                            GridRow {
                                choice.image
                                    .gridCellAnchor(.center)
                                    .foregroundColor(.white)
                                Picker("", selection: Binding<Accidental>(
                                    get: { instrument.accidental },
                                    set: { instrument.accidental = $0 }
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
    
    // MARK: – Helpers to bind each choice to its array membership
    
    private func pitchBinding(for choice: PitchLabelChoice) -> Binding<Bool> {
        Binding(
            get: {
                instrument.pitchLabelChoices.contains(choice)
            },
            set: { isOn in
                try? modelContext.transaction {
                    if isOn {
                        // inserting into a Set is idempotent
                        instrument.pitchLabelChoices.insert(choice)
                    } else {
                        instrument.pitchLabelChoices.remove(choice)
                    }
                }
            }
        )
    }
    
    private func intervalBinding(for choice: IntervalLabelChoice) -> Binding<Bool> {
        Binding(
            get: {
                instrument.intervalLabelChoices.contains(choice)
            },
            set: { isOn in
                try? modelContext.transaction {
                    if isOn {
                        instrument.intervalLabelChoices.insert(choice)
                    } else {
                        instrument.intervalLabelChoices.remove(choice)
                    }
                }
            }
        )
    }
}
