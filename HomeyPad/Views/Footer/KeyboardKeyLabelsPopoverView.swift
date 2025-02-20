//
//  KeyLabelsPopoverView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 4/5/24.
//

import SwiftUI
import HomeyMusicKit
struct KeyboardKeyLabelsPopoverView: View {
    @ObservedObject var viewConductor: ViewConductor
    
    var body: some View {
        VStack(spacing: 0.0) {
            Grid {
                ForEach(NoteLabelChoice.allCases, id: \.self) {key in
                    if key != .octave && key != .accidentals {
                        GridRow {
                            key.image
                                .gridCellAnchor(.center)
                                .foregroundColor(.white)
                            Toggle(key.label,
                                   isOn: viewConductor.noteLabelBinding(for: key))
                            .tint(Color.gray)
                            .foregroundColor(.white)
                        }
                        if key == .letter {
                            GridRow {
                                Image(systemName: NoteLabelChoice.accidentals.icon)
                                    .gridCellAnchor(.center)
                                    .foregroundColor(viewConductor.enableAccidentalPicker() ? .white : Color(UIColor.darkGray))
                                Picker("", selection: $viewConductor.accidental) {
                                    ForEach(Accidental.displayCases) { accidental in
                                        Text(accidental.icon)
                                            .tag(accidental as Accidental)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .disabled(!viewConductor.enableAccidentalPicker())
                            }
                            GridRow {
                                Image(systemName: "4.square")
                                    .gridCellAnchor(.center)
                                    .foregroundColor(viewConductor.enableOctavePicker() ? .white : Color(UIColor.darkGray))
                                Toggle(NoteLabelChoice.octave.label,
                                       isOn: viewConductor.noteLabelBinding(for: .octave))
                                .tint(Color.gray)
                                .foregroundColor(viewConductor.enableOctavePicker() ? .white : Color(UIColor.darkGray))
                                .disabled(!viewConductor.enableOctavePicker())
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
                               isOn: viewConductor.intervalLabelBinding(for: key))
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
