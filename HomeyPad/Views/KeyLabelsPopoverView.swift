//
//  KeyLabelsPopoverView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 4/5/24.
//

import SwiftUI

struct KeyLabelsPopoverView: View {
    @StateObject var viewConductor: ViewConductor
    
    var enableOctave: Bool {
        viewConductor.noteLabels[viewConductor.layoutChoice]![NoteLabelChoice.letter]! ||
        viewConductor.noteLabels[viewConductor.layoutChoice]![NoteLabelChoice.fixedDo]! ||
        viewConductor.noteLabels[viewConductor.layoutChoice]![NoteLabelChoice.month]!
    }
    
    var body: some View {
        VStack(spacing: 0.0) {
            Image(systemName: viewConductor.layoutChoice.icon)
            Divider()
                .padding([.top, .bottom], 9)
            Grid {
                ForEach(NoteLabelChoice.allCases, id: \.self) {key in
                    if key != .octave && key != .accidentals {
                        GridRow {
                            if key == .midi {
                                Image(key.icon)
                                    .gridCellAnchor(.center)
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: key.icon)
                                    .gridCellAnchor(.center)
                                    .foregroundColor(.white)
                            }
                            Toggle(key.label,
                                   isOn: viewConductor.noteLabelBinding(for: key))
                            .tint(Color.gray)
                            .foregroundColor(.white)
                        }
                    } else if key == .accidentals && viewConductor.showLetters {
                        GridRow {
                            let _: Void = UISegmentedControl.appearance().setTitleTextAttributes(
                                [.font: UIFont.systemFont(ofSize: 25)], for: .normal)
                            Image(systemName: key.icon)
                                .gridCellAnchor(.center)
                                .foregroundColor(.white)
                            Picker("", selection: $viewConductor.accidentalChoices[viewConductor.layoutChoice]) {
                                ForEach(AccidentalChoice.allCases) { accidentalChoice in
                                    Text(accidentalChoice.icon)
                                        .tag(accidentalChoice as AccidentalChoice?)
                                        .font(.title)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    } else if key == .octave  && viewConductor.showLetters {
                        GridRow {
                            Image(systemName: key.icon)
                                .gridCellAnchor(.center)
                                .foregroundColor(.white)
                            Toggle(key.label,
                                   isOn: viewConductor.noteLabelBinding(for: key))
                            .tint(Color.gray)
                            .foregroundColor(.white)
                        }
                    }
                }
                Divider()
                
                ForEach(IntervalLabelChoice.allCases, id: \.self) {key in
                    GridRow {
                        Image(systemName: key.icon)
                            .gridCellAnchor(.center)
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
