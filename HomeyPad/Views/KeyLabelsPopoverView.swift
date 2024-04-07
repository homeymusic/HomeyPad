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
                
                ForEach(IntervalLabelChoice.allCases, id: \.self) {key in
                    
                    if key == .symbol {
                        Divider()
                    }
                    
                    GridRow {
                        Image(systemName: key.icon)
                            .gridCellAnchor(.center)
                        Toggle(key.label,
                               isOn: viewConductor.intervalLabelBinding(for: key))
                        .tint(Color.gray)
                    }
                }

                Divider()

                ForEach(NoteLabelChoice.allCases, id: \.self) {key in
                        GridRow {
                            // SwiftUI has a different key signature for system versus custom images
                            // so we need this conditional to look for our custom image
                            if key == .midi {
                                Image(key.icon)
                                    .gridCellAnchor(.center)
                                    .foregroundColor(key == .octave && !enableOctave ? Color(UIColor.darkGray) : .white)
                            } else {
                                Image(systemName: key.icon)
                                    .gridCellAnchor(.center)
                                    .foregroundColor(key == .octave && !enableOctave ? Color(UIColor.darkGray) : .white)
                            }
                            Toggle(key.label,
                                   isOn: viewConductor.noteLabelBinding(for: key))
                            .tint(Color.gray)
                            .foregroundColor(key == .octave && !enableOctave ? Color(UIColor.darkGray) : .white)
                        }
                        .disabled(key == .octave && !enableOctave)
                }
                
            }
        }
        .padding(10)
    }
    
}

