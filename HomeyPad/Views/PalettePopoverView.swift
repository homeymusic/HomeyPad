//
//  PalettePopoverView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 4/5/24.
//

import SwiftUI

struct PalettePopoverView: View {
    @StateObject var viewConductor: ViewConductor
    
    var body: some View {
        VStack(spacing: 0.0) {
            Picker("", selection: $viewConductor.paletteChoices[viewConductor.layoutChoice]) {
                ForEach(PaletteChoice.allCases) { paletteChoice in
                    Image(systemName: paletteChoice.icon)
                        .tag(paletteChoice as PaletteChoice?)
                }
            }
            .pickerStyle(.segmented)
            .padding(10)
            
            Divider()

            Button(action: {
                viewConductor.resetPaletteChoice()
            }, label: {
                Image(systemName: "gobackward")
                    .gridCellAnchor(.center)
                    .foregroundColor(viewConductor.isPaletteDefault ? .gray : .white)
            })
            .padding([.top, .bottom], 7)
            .disabled(viewConductor.isPaletteDefault)
            
        }
    }
}
