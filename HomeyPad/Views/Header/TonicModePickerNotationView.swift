import SwiftUI
import HomeyMusicKit

public struct TonicModePickerNotationView: View {
    @Environment(AppContext.self) var appContext
    @Environment(\.modelContext) var modelContext
    @Bindable public var tonalityInstrument: TonalityInstrument
    
    private var tonicPicker: TonicPicker {
        modelContext.singletonInstrument(for: .tonicPicker) as! TonicPicker
    }

    private var instrument: MusicalInstrument {
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
                            Image(systemName: MusicalInstrumentType.tonicPicker.filledIcon)
                        }
                        if tonalityInstrument.showModePicker {
                            Image(systemName: MusicalInstrumentType.modePicker.filledIcon)
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
                        tonicPicker.resetDefaultLabelTypes()
                        buzz()
                    }, label: {
                        Image(systemName: "gobackward")
                            .gridCellAnchor(.center)
                            .foregroundColor(tonicPicker.areDefaultLabelTypes ? .gray : .white)
                    })
                    .gridCellColumns(2)
                    .disabled(tonicPicker.areDefaultLabelTypes)
                    .padding([.top, .bottom], 7)
                }
            })
            .transition(.scale)
            
            Button(action: {
                withAnimation {
                    print("before toggle tonalityInstrument.showTonicPicker", tonalityInstrument.showTonicPicker)
                    tonalityInstrument.showTonicPicker.toggle()
                    print("after toggle tonalityInstrument.showTonicPicker", tonalityInstrument.showTonicPicker)
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
                        instrument.showOutlines = true
                    }
                    instrument.showModeOutlines = tonalityInstrument.showModePicker
                    tonicPicker.showModeOutlines = tonalityInstrument.showModePicker
                }
            }
        }
        .onChange(of: shouldAutoModeAndTonicBeEnabled) {
            tonicPicker.isAutoModeAndTonicEnabled = shouldAutoModeAndTonicBeEnabled
        }
        // also seed it once when the view first appears
        .onAppear {
            tonicPicker.isAutoModeAndTonicEnabled = shouldAutoModeAndTonicBeEnabled
        }

    }
}
