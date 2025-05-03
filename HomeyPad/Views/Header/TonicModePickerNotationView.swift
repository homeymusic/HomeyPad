import SwiftUI
import HomeyMusicKit

public struct TonicModePickerNotationView: View {
    @Environment(AppContext.self) var appContext
    @Environment(\.modelContext) var modelContext
    
    private var tonicPicker: TonicPicker {
        modelContext.singletonInstrument(for: .tonicPicker) as! TonicPicker
    }

    private var instrument: MusicalInstrument {
        modelContext.singletonInstrument(for: appContext.instrumentType)
    }
    
    public init() { }
    public var body: some View {
        @Bindable var appContext = appContext
        let shouldAutoModeAndTonicBeEnabled = appContext.showTonicPicker && appContext.showModePicker

        HStack {
            
            Button(action: {
                appContext.showTonicModeLabelsPopover.toggle()
                buzz()
            }) {
                Color.clear.overlay(
                    Image(systemName: "tag")
                        .foregroundColor(!(appContext.showTonicPicker || appContext.showModePicker) ? .gray : .white)
                        .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                )
                .aspectRatio(1.0, contentMode: .fit)
            }
            .disabled(!(appContext.showTonicPicker || appContext.showModePicker))
            .popover(isPresented: $appContext.showTonicModeLabelsPopover, content: {
                VStack(spacing: 0) {
                    HStack(spacing: 3) {
                        if appContext.showTonicPicker {
                            Image(systemName: InstrumentType.tonicPicker.filledIcon)
                        }
                        if appContext.showModePicker {
                            Image(systemName: InstrumentType.modePicker.filledIcon)
                        }
                    }
                    .padding([.top, .bottom], 7)
                    Divider()
                    ScrollView(.vertical) {
                        TonicModePickerNotationPopoverView()
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
                    appContext.showTonicPicker.toggle()
                    buzz()
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: appContext.showTonicPicker ? InstrumentType.tonicPicker.filledIcon : InstrumentType.tonicPicker.icon)
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
                .padding(30.0)
            }
            
            Button(action: {
                withAnimation {
                    appContext.showModePicker.toggle()
                    buzz()
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: appContext.showModePicker ? InstrumentType.modePicker.filledIcon :
                                InstrumentType.modePicker.icon)
                        .foregroundColor(.white)
                        .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .onChange(of: appContext.showModePicker) {
                withAnimation {
                    if appContext.showModePicker {
                        instrument.showOutlines = true
                    }
                    instrument.showModeOutlines = appContext.showModePicker
                    tonicPicker.showModeOutlines = appContext.showModePicker
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
