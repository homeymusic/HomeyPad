import SwiftUI
import HomeyMusicKit

struct TonicPickerSettingsView: View {
    @ObservedObject var tonicConductor: ViewConductor
    @ObservedObject var modeConductor: ViewConductor
    
    @Binding var showTonicPicker: Bool

    @EnvironmentObject var tonalContext: TonalContext
    @EnvironmentObject var notationalTonicContext: NotationalTonicContext

    var body: some View {
        HStack {
            
            if showTonicPicker {
                Button(action: {
                    notationalTonicContext.showLabelsPopover.toggle()
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
                .popover(isPresented: $notationalTonicContext.showLabelsPopover,
                         content: {
                    VStack(spacing: 0) {
                        Image(systemName: LayoutChoice.tonic.icon + ".fill")
                            .padding([.top, .bottom], 7)
                        Divider()
                        ScrollView(.vertical) {
                            TonicPickerPitchLabelsPopoverView(tonicConductor: tonicConductor, modeConductor: modeConductor)
                                .presentationCompactAdaptation(.popover)
                        }
                        .scrollIndicatorsFlash(onAppear: true)
                        Divider()
                        Button(action: {
                            notationalTonicContext.resetLabels(for: InstrumentType.tonicPicker)
                        }, label: {
                            Image(systemName: "gobackward")
                                .gridCellAnchor(.center)
                                .foregroundColor(notationalTonicContext.areLabelsDefault(for: InstrumentType.tonicPicker) ? .gray : .white)
                        })
                        .gridCellColumns(2)
                        .disabled(notationalTonicContext.areLabelsDefault(for: InstrumentType.tonicPicker))
                        .padding([.top, .bottom], 7)
                    }
                })
                .transition(.scale)
            }
            
            Button(action: {
                withAnimation {
                    showTonicPicker.toggle()
                    buzz()
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: showTonicPicker ? LayoutChoice.tonic.icon + ".fill" : LayoutChoice.tonic.icon)
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
                .padding(30.0)
            }
            
            if showTonicPicker {
                Button(action: {
                    tonalContext.resetToDefault()
                }) {
                    ZStack {
                        Color.clear.overlay(
                            Image(systemName: "gobackward")
                                .foregroundColor(tonalContext.isDefault ? .gray : .white)
                                .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                    }
                }
                .transition(.scale)
                .disabled(tonalContext.isDefault)
            }
        }
    }
}
