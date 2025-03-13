import SwiftUI
import HomeyMusicKit

struct InstrumentAndPalletePickerView: View {
    @EnvironmentObject var tonalContext: TonalContext
    @EnvironmentObject var instrumentalContext: InstrumentalContext
    @EnvironmentObject var notationalContext: NotationalContext
    
    var body: some View {
        Button(action: {
            notationalContext.showLabelsPopover.toggle()
        }) {
            ZStack {
                Image(systemName: "tag")
                    .foregroundColor(.white)
                    .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
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
                    KeyboardKeyLabelsPopoverView()
                        .presentationCompactAdaptation(.popover)
                }
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
        .padding(.trailing, 5)
        
        HStack {
            Picker("", selection: $instrumentalContext.instrumentType) {
                ForEach(instrumentalContext.instruments, id:\.self) { instrument in
                    Image(systemName: instrument.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 160, maxWidth: .infinity)
                        .tag(instrument)
                }
            }
            .pickerStyle(.segmented)
        }
        
        Button(action: {
            notationalContext.showPalettePopover.toggle()
        }) {
            ZStack {
                Image(systemName: ColorPaletteChoice.subtle.icon)
                    .foregroundColor(.white)
                    .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
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
        .padding(.leading, 5)
    }
}
