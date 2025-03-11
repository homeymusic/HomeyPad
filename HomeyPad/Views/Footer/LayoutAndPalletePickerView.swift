import SwiftUI
import HomeyMusicKit

struct LayoutAndPalletePickerView: View {
    @ObservedObject var viewConductor: ViewConductor
    
    @EnvironmentObject var tonalContext: TonalContext
    @EnvironmentObject var instrumentalContext: InstrumentalContext
    @EnvironmentObject var notationalContext: NotationalContext
    
    var body: some View {
        HStack(spacing: 0) {
            
            Button(action: {
                notationalContext.showLabelsPopover.toggle()
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
            .popover(isPresented: $notationalContext.showLabelsPopover,
                     content: {
                VStack(spacing: 0) {
                    Image(systemName: instrumentalContext.instrumentType.icon)
                        .padding([.top, .bottom], 7)
                    Divider()
                    ScrollView(.vertical) {
                        KeyboardKeyLabelsPopoverView(viewConductor: viewConductor)
                            .presentationCompactAdaptation(.popover)
                    }
                    .scrollIndicatorsFlash(onAppear: true)
                    Divider()
                    Button(action: {
                        notationalContext.resetLabels(for: instrumentalContext.instrumentType)
                    }, label: {
                        Image(systemName: "gobackward")
                            .gridCellAnchor(.center)
                            .foregroundColor(notationalContext.areLabelsDefault(for: instrumentalContext.instrumentType) ? .gray : .white)
                    })
                    .gridCellColumns(2)
                    .disabled(notationalContext.areLabelsDefault(for: instrumentalContext.instrumentType))
                    .padding([.top, .bottom], 7)
                }
            })
            .padding(.trailing, 10)
            
            Picker("", selection: $instrumentalContext.instrumentType) {
                ForEach(instrumentalContext.instruments, id:\.self) { instrument in
                    Image(systemName: instrument.icon)
                        .tag(instrument)
                }
            }
            .frame(maxWidth: 300)
            .pickerStyle(.segmented)
                                    
            Button(action: {
                notationalContext.showPalettePopover.toggle()
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: ColorPaletteChoice.subtle.icon)
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .popover(isPresented: $notationalContext.showPalettePopover,
                     content: {
                VStack(spacing: 0) {
                    Image(systemName: instrumentalContext.instrumentType.icon)
                        .padding([.top, .bottom], 7)
                    Divider()
                    ScrollView(.vertical) {
                        PalettePopoverView()
                            .presentationCompactAdaptation(.popover)
                    }
                    .scrollIndicatorsFlash(onAppear: true)

                    Divider()
                    
                    Button(action: {
                        notationalContext.resetColorPalette(for: instrumentalContext.instrumentType)
                    }, label: {
                        Image(systemName: "gobackward")
                            .gridCellAnchor(.center)
                            .foregroundColor(notationalContext.isColorPaletteDefault(for: instrumentalContext.instrumentType) ? .gray : .white)
                    })
                    .padding([.top, .bottom], 7)
                    .disabled(notationalContext.isColorPaletteDefault(for: instrumentalContext.instrumentType))
                                                        
                }
            })
            .padding(.leading, 10)
        }
    }
}
