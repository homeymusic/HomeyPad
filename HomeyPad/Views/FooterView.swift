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
                
                Button(action: {
                    viewConductor.showKeyLabelsPopover.toggle()
                }) {
                    ZStack {
                        Color.clear.overlay(
                            Image(systemName: "tag")
                                .foregroundColor(.white)
                                .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                    }
                }
                .popover(isPresented: $viewConductor.showKeyLabelsPopover,
                         content: {
                    ScrollView {
                        KeyLabelsPopoverView(viewConductor: viewConductor)
                            .presentationCompactAdaptation(.popover)
                    }
                    .scrollIndicatorsFlash(onAppear: true)
                })
                .padding(.trailing, 10)
                
                Picker("", selection: $viewConductor.layoutChoice) {
                    ForEach(LayoutChoice.allCases) { layoutChoice in
                        Image(systemName: layoutChoice.icon)
                            .tag(layoutChoice)
                    }
                }
                .frame(maxWidth: 300)
                .pickerStyle(.segmented)
                
                
                Button(action: {
                    viewConductor.showPalettePopover.toggle()
                }) {
                    ZStack {
                        Color.clear.overlay(
                            Image(systemName: viewConductor.paletteChoice[viewConductor.layoutChoice]!.icon)
                                .foregroundColor(.white)
                                .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                    }
                }
                .popover(isPresented: $viewConductor.showPalettePopover,
                         content: {
                    PalettePopoverView(viewConductor: viewConductor)
                        .presentationCompactAdaptation(.popover)
                })
                .padding(.leading, 10)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
