//
//  KeyboardLayoutPickerView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/24/24.
//

import SwiftUI

struct FooterView: View {
    @StateObject var viewConductor: ViewConductor
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(systemName: "slider.horizontal.3")
                
                Picker("", selection: $viewConductor.layoutChoice) {
                    ForEach(LayoutChoice.allCases) { layoutChoice in
                        Image(systemName: layoutChoice.icon)
                            .tag(layoutChoice)
                    }
                }
                .frame(maxWidth: 300)
                .pickerStyle(.segmented)
                Spacer()
                Picker("", selection: $viewConductor.paletteChoice[viewConductor.layoutChoice]) {
                    ForEach(PaletteChoice.allCases) { paletteChoice in
                        Image(systemName: paletteChoice.icon)
                            .tag(paletteChoice as PaletteChoice?)
                    }
                }
                .frame(maxWidth: 300)
                .pickerStyle(.segmented)
            }
            .frame(maxWidth: .infinity)
            HStack(spacing: 0) {
                ForEach(NoteLabelChoice.allCases, id: \.self) {key in
                    Toggle(key.label,
                           systemImage: key.icon,
                           isOn: viewConductor.noteLabelBinding(for: key))
                }
            }
            .frame(maxWidth: .infinity)
            HStack(spacing: 0) {
                ForEach(IntervalLabelChoice.allCases, id: \.self) {key in
                    Toggle(key.label,
                           systemImage: key.icon,
                           isOn: viewConductor.intervalLabelBinding(for: key))
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
