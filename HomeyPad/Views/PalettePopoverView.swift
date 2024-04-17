//
//  PalettePopoverView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 4/5/24.
//

import SwiftUI

struct PalettePopoverView: View {
    @ObservedObject var conductor: ViewConductor
    
    var body: some View {
        VStack(spacing: 10.0) {
            Picker("", selection: $conductor.layoutPalette.choices[conductor.layoutChoice]) {
                ForEach(PaletteChoice.allCases) { paletteChoice in
                    Image(systemName: paletteChoice.icon)
                        .tag(paletteChoice as PaletteChoice?)
                }
            }
            .pickerStyle(.segmented)

            Grid {
                GridRow {
                    Image(systemName: "pencil.and.outline")
                        .gridCellAnchor(.center)
                        .foregroundColor(.white)
                    Toggle(LayoutPalette.outlineLabel,
                           isOn: conductor.outlineBinding())
                    .tint(Color.gray)
                    .foregroundColor(.white)
                }
            }
        }
        .padding(10)
    }
}
