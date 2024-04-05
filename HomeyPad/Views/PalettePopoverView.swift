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
        let spacing = 0.0
            Picker("", selection: $viewConductor.paletteChoice[viewConductor.layoutChoice]) {
                ForEach(PaletteChoice.allCases) { paletteChoice in
                    Image(systemName: paletteChoice.icon)
                        .tag(paletteChoice as PaletteChoice?)
                }
            }
            .pickerStyle(.segmented)
            .padding(10)
    }
}
