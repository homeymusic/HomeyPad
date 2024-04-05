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
                Picker("", selection: $viewConductor.layoutChoice) {
                    ForEach(LayoutChoice.allCases) { layoutChoice in
                        Image(systemName: layoutChoice.icon)
                            .tag(layoutChoice)
                    }
                }
                .frame(maxWidth: 300)
                .pickerStyle(.segmented)
                
                /// show or hide label picker for tonic selector
                Button(action: {
                    viewConductor.showKeyLabelsPopover.toggle()
                }) {
                    ZStack {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.white)
                        Image(systemName: "square").foregroundColor(.clear)
                    }
                }
                .popover(isPresented: $viewConductor.showKeyLabelsPopover,
                         content: {
                    KeyLabelsPopoverView(viewConductor: viewConductor)
                        .presentationCompactAdaptation(.none)
                })
                .padding(.leading, 10)
                //
                //                Spacer()
                //                Picker("", selection: $viewConductor.paletteChoice[viewConductor.layoutChoice]) {
                //                    ForEach(PaletteChoice.allCases) { paletteChoice in
                //                        Image(systemName: paletteChoice.icon)
                //                            .tag(paletteChoice as PaletteChoice?)
                //                    }
                //                }
                //                .frame(maxWidth: 300)
                //                .pickerStyle(.segmented)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
