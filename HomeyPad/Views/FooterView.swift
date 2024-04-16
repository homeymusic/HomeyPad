//
//  KeyboardLayoutPickerView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/24/24.
//

import SwiftUI

struct FooterView: View {
    @ObservedObject var viewConductor: ViewConductor
    
    var body: some View {
        HStack {
            
            Button(action: {
                viewConductor.latching.toggle()
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: viewConductor.latching ? "pin.fill" : "pin.slash")
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: viewConductor.latching ? .black : .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            LayoutAndPalletePickerView(viewConductor: viewConductor)
            
            HStack {
                if viewConductor.layoutChoice == .strings {
                    Picker("", selection: $viewConductor.stringsLayoutChoice) {
                        ForEach(StringsLayoutChoice.allCases) { stringsLayoutChoice in
                            Text(stringsLayoutChoice.icon.capitalized)
                                .tag(stringsLayoutChoice)
                                .font(Font.system(size: 17))
                        }
                    }
                    .frame(maxWidth: 240)
                    .pickerStyle(.segmented)
                } else {
                    RowsColsPickerView(viewConductor: viewConductor)
                }
            }
            .foregroundColor(.white)
            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
            .frame(maxWidth: .infinity, alignment: .trailing)
            .animation(viewConductor.animationStyle, value: viewConductor.layoutChoice)
        }
    }
}

