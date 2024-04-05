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
                        Image(systemName: "tag")
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                        Image(systemName: "square").foregroundColor(.clear)
                    }
                }
                .popover(isPresented: $viewConductor.showKeyLabelsPopover,
                         content: {
                    KeyLabelsPopoverView(viewConductor: viewConductor)
                        .presentationCompactAdaptation(.none)
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
                        Image(systemName: viewConductor.paletteChoice[viewConductor.layoutChoice]!.icon)
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                        Image(systemName: "square").foregroundColor(.clear)
                    }
                }
                .popover(isPresented: $viewConductor.showPalettePopover,
                         content: {
                    PalettePopoverView(viewConductor: viewConductor)
                        .presentationCompactAdaptation(.none)
                })
                .padding(.leading, 10)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
