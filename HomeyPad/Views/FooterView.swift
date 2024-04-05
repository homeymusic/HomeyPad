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
            
            Spacer()
            
            let labelChoices = viewConductor.showLabels.filter({$0.layout == viewConductor.layoutChoice}).first!
            ForEach(labelChoices.allIntervalKeys, id: \.self) {key in
                Toggle(isOn: labelChoices.intervalBinding(for: key)) {
                    Text("\(key): \(labelChoices.intervalLabels[key]!)")
                }
            }            

        }
        .frame(maxWidth: .infinity)
    }
}
