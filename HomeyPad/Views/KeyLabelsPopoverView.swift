//
//  KeyLabelsPopoverView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 4/5/24.
//

import SwiftUI

struct KeyLabelsPopoverView: View {
    @StateObject var viewConductor: ViewConductor
    
    var body: some View {
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
                                   isOn: viewConductor.noteLabelBinding(for: key))
                            .tint(Color.gray)
                            .foregroundColor(.white)
                        }
                        if key == .letter {
                            GridRow {
                                let _: Void = UISegmentedControl.appearance().setTitleTextAttributes(
                                    [.font: UIFont.systemFont(ofSize: 25)], for: .normal)
                                Image(systemName: "arrow.down.left.arrow.up.right.square")
                                    .gridCellAnchor(.center)
                                    .foregroundColor(viewConductor.showLetters ? .white : Color(UIColor.darkGray))
                                Picker("", selection: $viewConductor.accidentalChoices[viewConductor.layoutChoice]) {
                                    ForEach(AccidentalChoice.allCases) { accidentalChoice in
                                        Text(accidentalChoice.icon)
                                            .tag(accidentalChoice as AccidentalChoice?)
                                            .font(.title)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .disabled(!viewConductor.showLetters)
                            }
                            GridRow {
                                Image(systemName: "4.square")
                                    .gridCellAnchor(.center)
                                    .foregroundColor(viewConductor.showLetters ? .white : Color(UIColor.darkGray))
                                Toggle(NoteLabelChoice.octave.label,
                                       isOn: viewConductor.noteLabelBinding(for: .octave))
                                .tint(Color.gray)
                                .foregroundColor(viewConductor.showLetters ? .white : Color(UIColor.darkGray))
                                .disabled(!viewConductor.showLetters)
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
