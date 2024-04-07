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
        let spacing = 0.0
        VStack(spacing: spacing) {
            Grid {
                
                ForEach(NoteLabelChoice.allCases, id: \.self) {key in
                    GridRow {
                        Image(systemName: key.icon)
                            .gridCellAnchor(.center)
                        Toggle(key.label,
                               isOn: viewConductor.noteLabelBinding(for: key))
                        .tint(Color.gray)
                    }
                }
                
                Divider()
                GridRow {
                    Image(systemName: "diamond")
                        .gridCellAnchor(.center)
                    Toggle("Symbols",
                           isOn: $viewConductor.showSymbols)
                    .tint(Color.gray)
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
                }
            }
        }
        .padding(10)
    }
    
}

