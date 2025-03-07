import SwiftUI
import HomeyMusicKit

struct LayoutAndPalletePickerView: View {
    @ObservedObject var viewConductor: ViewConductor
    
    @EnvironmentObject var instrumentContext: InstrumentContext
    @EnvironmentObject var tonalContext: TonalContext
    
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
                        KeyboardKeyLabelsPopoverView(viewConductor: viewConductor)
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
            
            Picker("", selection: $instrumentContext.instrumentType) {
                ForEach(instrumentContext.instruments, id:\.self) { instrument in
                    Image(systemName: instrument.icon)
                        .tag(instrument)
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
