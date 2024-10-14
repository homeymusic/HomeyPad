import SwiftUI
import HomeyMusicKit

struct TonicPickerSettingsView: View {
    @ObservedObject var tonicConductor: ViewConductor
    @Binding var showTonicPicker: Bool
    
    var body: some View {
        HStack {
            
            if showTonicPicker {
                Button(action: {
                    tonicConductor.showKeyLabelsPopover.toggle()
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
                .popover(isPresented: $tonicConductor.showKeyLabelsPopover,
                         content: {
                    VStack(spacing: 0) {
                        Image(systemName: LayoutChoice.tonic.icon + ".fill")
                            .padding([.top, .bottom], 7)
                        Divider()
                        ScrollView(.vertical) {
                            KeyboardKeyLabelsPopoverView(viewConductor: tonicConductor)
                                .presentationCompactAdaptation(.popover)
                        }
                        .scrollIndicatorsFlash(onAppear: true)
                        Divider()
                        Button(action: {
                            tonicConductor.resetLabels()
                        }, label: {
                            Image(systemName: "gobackward")
                                .gridCellAnchor(.center)
                                .foregroundColor(tonicConductor.areLabelsDefault ? .gray : .white)
                        })
                        .gridCellColumns(2)
                        .disabled(tonicConductor.areLabelsDefault)
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
                    tonicConductor.resetTonic()
                }) {
                    ZStack {
                        Color.clear.overlay(
                            Image(systemName: "gobackward")
                                .foregroundColor(tonicConductor.isTonicDefault ? .gray : .white)
                                .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                    }
                }
                .transition(.scale)
                .disabled(tonicConductor.isTonicDefault)
            }            
        }
    }
}
