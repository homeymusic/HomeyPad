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
                }
            }
            .foregroundColor(.white)
            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
            .frame(maxWidth: .infinity, alignment: .trailing)
            .animation(viewConductor.animationStyle, value: viewConductor.layoutChoice)
        }
    }
}

struct LayoutAndPalletePickerView: View {
    @StateObject var viewConductor: ViewConductor
    
    var body: some View {
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
                VStack(spacing: 0) {
                    Image(systemName: viewConductor.layoutChoice.icon)
                        .padding([.top, .bottom], 7)
                    Divider()
                    ScrollView(.vertical) {
                        KeyLabelsPopoverView(viewConductor: viewConductor)
                            .presentationCompactAdaptation(.popover)
                    }
                    .scrollIndicatorsFlash(onAppear: true)
                    Divider()
                    Button(action: {
                        viewConductor.resetLabels()
                    }, label: {
                        Image(systemName: "gobackward")
                            .gridCellAnchor(.center)
                            .foregroundColor(viewConductor.areLabelsDefault ? .gray : .white)
                    })
                    .gridCellColumns(2)
                    .disabled(viewConductor.areLabelsDefault)
                    .padding([.top, .bottom], 7)
                }
            })
            .padding(.trailing, 10)

            
            
            Picker("", selection: $viewConductor.layoutChoice) {
                ForEach(LayoutChoice.allCases, id:\.self) { layoutChoice in
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
                        Image(systemName: viewConductor.paletteChoice.icon)
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .popover(isPresented: $viewConductor.showPalettePopover,
                     content: {
                VStack(spacing: 0) {
                    Image(systemName: viewConductor.layoutChoice.icon)
                        .padding([.top, .bottom], 7)
                    Divider()
                    PalettePopoverView(viewConductor: viewConductor)
                        .presentationCompactAdaptation(.popover)
                }
            })
            .padding(.leading, 10)
        }
    }
}
