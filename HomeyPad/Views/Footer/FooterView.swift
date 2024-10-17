//
//  KeyboardLayoutPickerView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/24/24.
//

import SwiftUI
import HomeyMusicKit

struct FooterView: View {
    @ObservedObject var viewConductor: ViewConductor
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                withAnimation {
                    viewConductor.latching.toggle()
                }
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
                            Text(stringsLayoutChoice.label.capitalized)
                                .tag(stringsLayoutChoice)
                        }
                    }
                    .pickerStyle(.segmented)
                } else {
                    RowsColsPickerView(viewConductor: viewConductor)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .animation(viewConductor.animationStyle, value: viewConductor.layoutChoice)
        }
    }
}

