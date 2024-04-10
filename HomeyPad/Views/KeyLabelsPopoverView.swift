//
//  KeyLabelsPopoverView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 4/5/24.
//

import SwiftUI

struct KeyLabelsPopoverView: View {
    @StateObject var viewConductor: ViewConductor
    var homeLayout: Bool = false
    
    var body: some View {
        let layout: LayoutChoice = homeLayout ? .home : viewConductor.layoutChoice
        VStack(spacing: 0.0) {
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
                                   isOn: viewConductor.noteLabelBinding(for: key, homeLayout: homeLayout))
                            .tint(Color.gray)
                            .foregroundColor(.white)
                        }
                        if key == .fixedDo {
                            GridRow {
                                Image(systemName: "arrow.down.left.arrow.up.right.square")
                                    .gridCellAnchor(.center)
                                    .foregroundColor(viewConductor.enableAccidentalPicker(homeLayout: homeLayout) ? .white : Color(UIColor.darkGray))
                                Picker("", selection: $viewConductor.accidentalChoices[layout]) {
                                    ForEach(AccidentalChoice.allCases) { accidentalChoice in
                                        Text(accidentalChoice.icon)
                                            .tag(accidentalChoice as AccidentalChoice?)
                                            .font(.title)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .disabled(!viewConductor.enableAccidentalPicker(homeLayout: homeLayout))
                            }
                        }
                        if key == .month {
                            GridRow {
                                Image(systemName: "4.square")
                                    .gridCellAnchor(.center)
                                    .foregroundColor(viewConductor.enableOctavePicker(homeLayout: homeLayout) ? .white : Color(UIColor.darkGray))
                                Toggle(NoteLabelChoice.octave.label,
                                       isOn: viewConductor.noteLabelBinding(for: .octave))
                                .tint(Color.gray)
                                .foregroundColor(viewConductor.enableOctavePicker(homeLayout: homeLayout) ? .white : Color(UIColor.darkGray))
                                .disabled(!viewConductor.enableOctavePicker(homeLayout: homeLayout))
                            }
                        }
                    }
                }
                Divider()
                
                ForEach(IntervalLabelChoice.allCases, id: \.self) {key in
                    GridRow {
                        Image(systemName: key.icon)
                            .gridCellAnchor(.center)
                        Toggle(key.label,
                               isOn: viewConductor.intervalLabelBinding(for: key, homeLayout: homeLayout))
                        .tint(Color.gray)
                    }
                    if key == .symbol {
                        Divider()
                    }
                }

                Divider()
                
                GridRow {
                    Button(action: {
                        viewConductor.resetLabels(homeLayout: homeLayout)
                    }, label: {
                        Image(systemName: "gobackward")
                            .gridCellAnchor(.center)
                            .foregroundColor(.white)
                    })
                    .gridCellColumns(2)
                }
                .padding(.top, 3)

            }
            .padding(10)
        }
    }
}
