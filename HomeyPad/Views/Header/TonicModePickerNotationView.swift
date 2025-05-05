import SwiftUI
import HomeyMusicKit

public struct TonicModePickerNotationView: View {
    @Environment(AppContext.self) var appContext
    @Environment(\.modelContext) var modelContext
    @Bindable public var tonalityInstrument: TonalityInstrument
    
    private var musicalInstrument: MusicalInstrument {
        modelContext.singletonInstrument(for: appContext.instrumentType)
    }
    
    public var body: some View {
        @Bindable var appContext = appContext
        let shouldAutoModeAndTonicBeEnabled = tonalityInstrument.showTonicPicker && tonalityInstrument.showModePicker

        HStack {
            
            Button(action: {
                appContext.showTonicModeLabelsPopover.toggle()
                buzz()
            }) {
                Color.clear.overlay(
                    Image(systemName: "tag")
                        .foregroundColor(!(tonalityInstrument.showTonicPicker || tonalityInstrument.showModePicker) ? .gray : .white)
                        .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                )
                .aspectRatio(1.0, contentMode: .fit)
            }
            .disabled(!(tonalityInstrument.showTonicPicker || tonalityInstrument.showModePicker))
            .popover(isPresented: $appContext.showTonicModeLabelsPopover, content: {
                VStack(spacing: 0) {
                    HStack(spacing: 3) {
                        if tonalityInstrument.showTonicPicker {
                            Image(systemName: TonalityInstrumentType.tonicPicker.filledIcon)
                        }
                        if tonalityInstrument.showModePicker {
                            Image(systemName: TonalityInstrumentType.modePicker.filledIcon)
                        }
                    }
                    .padding([.top, .bottom], 7)
                    Divider()
                    ScrollView(.vertical) {
                        TonicModePickerNotationPopoverView(tonalityInstrument: modelContext.tonalityInstrument())
                            .presentationCompactAdaptation(.none)
                    }
                    Divider()
                    Button(action: {
                        tonalityInstrument.resetDefaultLabelTypes()
                        buzz()
                    }, label: {
                        Image(systemName: "gobackward")
                            .gridCellAnchor(.center)
                            .foregroundColor(tonalityInstrument.areDefaultLabelTypes ? .gray : .white)
                    })
                    .gridCellColumns(2)
                    .disabled(tonalityInstrument.areDefaultLabelTypes)
                    .padding([.top, .bottom], 7)
                }
            })
            .transition(.scale)
            
            Button(action: {
                withAnimation {
                    tonalityInstrument.showTonicPicker.toggle()
                    buzz()
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: tonalityInstrument.showTonicPicker ? TonalityInstrumentType.tonicPicker.filledIcon : TonalityInstrumentType.tonicPicker.icon)
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
                .padding(30.0)
            }
            
            Button(action: {
                withAnimation {
                    tonalityInstrument.showModePicker.toggle()
                    buzz()
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: tonalityInstrument.showModePicker ? TonalityInstrumentType.modePicker.filledIcon :
                                TonalityInstrumentType.modePicker.icon)
                        .foregroundColor(.white)
                        .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .onChange(of: tonalityInstrument.showModePicker) {
                withAnimation {
                    if tonalityInstrument.showModePicker {
                        musicalInstrument.showOutlines = true
                    }
                    musicalInstrument.showModeOutlines = tonalityInstrument.showModePicker
                    tonalityInstrument.showModeOutlines = tonalityInstrument.showModePicker
                }
            }
        }
        .onChange(of: shouldAutoModeAndTonicBeEnabled) {
            tonalityInstrument.isAutoModeAndTonicEnabled = shouldAutoModeAndTonicBeEnabled
        }
        // also seed it once when the view first appears
        .onAppear {
            tonalityInstrument.isAutoModeAndTonicEnabled = shouldAutoModeAndTonicBeEnabled
        }

    }
}
