import SwiftUI

struct LayoutAndPalletePickerView: View {
    @ObservedObject var viewConductor: ViewConductor
    
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
                    ScrollView(.vertical) {
                        PalettePopoverView(conductor: viewConductor)
                            .presentationCompactAdaptation(.popover)
                    }
                    .scrollIndicatorsFlash(onAppear: true)

                    Divider()
                    
                    Button(action: {
                        viewConductor.resetPaletteChoice()
                    }, label: {
                        Image(systemName: "gobackward")
                            .gridCellAnchor(.center)
                            .foregroundColor(viewConductor.isPaletteDefault ? .gray : .white)
                    })
                    .padding([.top, .bottom], 7)
                    .disabled(viewConductor.isPaletteDefault)
                                                        
                }
            })
            .padding(.leading, 10)
        }
    }
}
