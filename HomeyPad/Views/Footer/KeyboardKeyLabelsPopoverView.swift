import SwiftUI
import HomeyMusicKit
struct KeyboardKeyLabelsPopoverView: View {
    @EnvironmentObject var tonalContext: TonalContext
    @EnvironmentObject var instrumentalContext: InstrumentalContext
    @EnvironmentObject var notationalContext: NotationalContext

    var body: some View {
        VStack(spacing: 0.0) {
            Grid {
                ForEach(NoteLabelChoice.pitchCases, id: \.self) {key in
                    if key != .octave && key != .accidentals {
                        GridRow {
                            key.image
                                .gridCellAnchor(.center)
                                .foregroundColor(.white)
                            Toggle(key.label,
                                   isOn: notationalContext.noteBinding(for: instrumentalContext.instrumentType, choice: key))
                            .tint(Color.gray)
                            .foregroundColor(.white)
                        }
                        if key == .letter {
                            GridRow {
                                Image(systemName: NoteLabelChoice.accidentals.icon)
                                    .gridCellAnchor(.center)
//                                    .foregroundColor(viewConductor.enableAccidentalPicker() ? .white : Color(UIColor.darkGray))
                                Picker("", selection: $tonalContext.accidental) {
                                    ForEach(Accidental.displayCases) { accidental in
                                        Text(accidental.icon)
                                            .tag(accidental as Accidental)
                                    }
                                }
                                .pickerStyle(.segmented)
//                                .disabled(!viewConductor.enableAccidentalPicker())
                            }
                            GridRow {
//                                Image(systemName: "4.square")
//                                    .gridCellAnchor(.center)
//                                    .foregroundColor(viewConductor.enableOctavePicker() ? .white : Color(UIColor.darkGray))
//                                Toggle(NoteLabelChoice.octave.label,
//                                       isOn: viewConductor.noteLabelBinding(for: .octave))
//                                .tint(Color.gray)
//                                .foregroundColor(viewConductor.enableOctavePicker() ? .white : Color(UIColor.darkGray))
//                                .disabled(!viewConductor.enableOctavePicker())
                            }
                        }
                    }
                }
                Divider()
                
                ForEach(IntervalLabelChoice.allCases, id: \.self) {key in
                    GridRow {
                        key.image
                            .gridCellAnchor(.center)
                            .foregroundColor(.white)
                        Toggle(key.label,
                               isOn: notationalContext.intervalBinding(for: instrumentalContext.instrumentType, choice: key))
                        .tint(Color.gray)
                    }
                    if key == .symbol {
                        Divider()
                    }
                }
            }
            .padding(10)
        }
    }
}
