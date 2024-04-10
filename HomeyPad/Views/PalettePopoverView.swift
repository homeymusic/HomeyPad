//
//  PalettePopoverView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 4/5/24.
//

import SwiftUI

struct PalettePopoverView: View {
    @StateObject var viewConductor: ViewConductor
    var homeLayout: Bool = false
    
    var body: some View {
        VStack(spacing: 0.0) {
            Picker("", selection: $viewConductor.paletteChoices[homeLayout ? .home : viewConductor.layoutChoice]) {
                ForEach(PaletteChoice.allCases) { paletteChoice in
                    Image(systemName: paletteChoice.icon)
                        .tag(paletteChoice as PaletteChoice?)
                }
            }
            .pickerStyle(.segmented)
            .padding(10)
            
            Divider()
            
            Button(action: {
                viewConductor.resetPaletteChoice(homeLayout: homeLayout)
            }, label: {
                Image(systemName: "gobackward")
                    .gridCellAnchor(.center)
                    .foregroundColor(.white)
            })
            .padding([.top, .bottom], 7)
            
        }
    }
}
