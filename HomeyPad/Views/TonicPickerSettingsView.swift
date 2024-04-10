import SwiftUI

struct TonicPickerSettingsView: View {
    @StateObject var viewConductor: ViewConductor
    
    var body: some View {
        HStack {
            
            if viewConductor.showTonicPicker {
                Button(action: {
                    viewConductor.showTonicKeyLabelsPopover.toggle()
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
                .popover(isPresented: $viewConductor.showTonicKeyLabelsPopover,
                         content: {
                    VStack(spacing: 0) {
                        Image(systemName: LayoutChoice.home.icon)
                            .padding([.top, .bottom], 7)
                        Divider()
                        ScrollView {
                            KeyLabelsPopoverView(viewConductor: viewConductor, homeLayout: true)
                                .presentationCompactAdaptation(.popover)
                        }
                        .scrollIndicatorsFlash(onAppear: true)
                    }
                })
                .transition(.scale)
            }
            
            Button(action: {
                withAnimation {
                    viewConductor.showTonicPicker.toggle()
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: viewConductor.showTonicPicker ? LayoutChoice.home.icon + ".fill" : LayoutChoice.home.icon)
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
                .padding(30.0)
            }
            
            if viewConductor.showTonicPicker {
                Button(action: {
                    viewConductor.showTonicPalettePopover.toggle()
                }) {
                    ZStack {
                        Color.clear.overlay(
                            Image(systemName: viewConductor.paletteChoices[.home]!.icon)
                                .foregroundColor(.white)
                                .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                    }
                }
                .popover(isPresented: $viewConductor.showTonicPalettePopover,
                         content: {
                    VStack(spacing: 0) {
                        Image(systemName: LayoutChoice.home.icon)
                            .padding([.top, .bottom], 7)
                        Divider()
                        PalettePopoverView(viewConductor: viewConductor, homeLayout: true)
                            .presentationCompactAdaptation(.popover)
                    }
                })
                .transition(.scale)
            }
            
        }
    }
}
