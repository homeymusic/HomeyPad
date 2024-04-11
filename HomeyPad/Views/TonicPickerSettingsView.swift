import SwiftUI

struct TonicPickerSettingsView: View {
    @StateObject var tonicConductor: ViewConductor
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
                        ScrollView {
                            KeyLabelsPopoverView(viewConductor: tonicConductor)
                                .presentationCompactAdaptation(.popover)
                        }
                        .scrollIndicatorsFlash(onAppear: true)
                    }
                })
                .transition(.scale)
            }
            
            Button(action: {
                withAnimation {
                    showTonicPicker.toggle()
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
                    tonicConductor.showPalettePopover.toggle()
                }) {
                    ZStack {
                        Color.clear.overlay(
                            Image(systemName: tonicConductor.paletteChoices[.tonic]!.icon)
                                .foregroundColor(.white)
                                .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                    }
                }
                .popover(isPresented: $tonicConductor.showPalettePopover,
                         content: {
                    VStack(spacing: 0) {
                        Image(systemName: LayoutChoice.tonic.icon + ".fill")
                            .padding([.top, .bottom], 7)
                        Divider()
                        PalettePopoverView(viewConductor: tonicConductor)
                            .presentationCompactAdaptation(.popover)
                    }
                })
                .transition(.scale)
            }
            
        }
    }
}
