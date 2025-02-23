import SwiftUI
import HomeyMusicKit
struct TonicPickerKeyLabelsPopoverView: View {
    @ObservedObject var tonicConductor: ViewConductor
    @ObservedObject var modeConductor: ViewConductor
    
    var body: some View {
        VStack(spacing: 0.0) {
            Grid {
                ForEach(NoteLabelChoice.pitchClassCases, id: \.self) {key in
                    if key != .accidentals {
                        GridRow {
                            key.image
                                .gridCellAnchor(.center)
                                .foregroundColor(.white)
                            Toggle(key.label,
                                   isOn: tonicConductor.noteLabelBinding(for: key))
                            .tint(Color.gray)
                            .foregroundColor(.white)
                        }
                        if key == .letter {
                            GridRow {
                                Image(systemName: NoteLabelChoice.accidentals.icon)
                                    .gridCellAnchor(.center)
                                    .foregroundColor(tonicConductor.enableAccidentalPicker() ? .white : Color(UIColor.darkGray))
                                Picker("", selection: $tonicConductor.accidental) {
                                    ForEach(Accidental.displayCases) { accidental in
                                        Text(accidental.icon)
                                            .tag(accidental as Accidental)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .disabled(!tonicConductor.enableAccidentalPicker())
                            }
                        }
                    }
                }
                
                Divider()
                
                ForEach(IntervalLabelChoice.intervalClassCases, id: \.self) {key in
                    GridRow {
                        key.image
                            .gridCellAnchor(.center)
                            .foregroundColor(.white)
                        Toggle(key.label,
                               isOn: tonicConductor.intervalLabelBinding(for: key))
                        .tint(Color.gray)
                    }
                    if key == .symbol {
                        Divider()
                    }
                }
                
                Divider()
                
                ForEach(NoteLabelChoice.modeCases, id: \.self) {key in
                    GridRow {
                        key.image
                            .gridCellAnchor(.center)
                            .foregroundColor(.white)
                        Toggle(key.label,
                               isOn: modeConductor.noteLabelBinding(for: key))
                        .tint(Color.gray)
                        .foregroundColor(.white)
                    }
                }
                
            }
            .padding(10)
        }
    }
}
