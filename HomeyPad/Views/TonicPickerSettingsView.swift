import SwiftUI

struct TonicPickerSettingsView: View {
    @StateObject var tonicConductor: ViewConductor
    
    var body: some View {
        HStack {
            
            if tonicConductor.showTonicPicker {
                Button(action: {
                    tonicConductor.showTonicKeyLabelsPopover.toggle()
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
                .popover(isPresented: $tonicConductor.showTonicKeyLabelsPopover,
                         content: {
                    VStack(spacing: 0) {
                        Image(systemName: LayoutChoice.tonic.icon)
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
                    tonicConductor.showTonicPicker.toggle()
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: tonicConductor.showTonicPicker ? LayoutChoice.tonic.icon + ".fill" : LayoutChoice.tonic.icon)
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
                .padding(30.0)
            }
            
            if tonicConductor.showTonicPicker {
                Button(action: {
                    tonicConductor.showTonicPalettePopover.toggle()
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
                .popover(isPresented: $tonicConductor.showTonicPalettePopover,
                         content: {
                    VStack(spacing: 0) {
                        Image(systemName: LayoutChoice.tonic.icon)
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
