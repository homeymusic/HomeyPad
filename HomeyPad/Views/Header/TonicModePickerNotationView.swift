import SwiftUI
import HomeyMusicKit

public struct TonicModePickerNotationView: View {
    @Environment(AppContext.self) var appContext
    @Environment(TonalContext.self) var tonalContext
    @Environment(NotationalContext.self) var notationalContext
    @Environment(InstrumentalContext.self) var instrumentalContext
    @Environment(\.modelContext) var modelContext
    
    private var tonicPicker: TonicPicker {
        modelContext.instrument(for: .tonicPicker) as! TonicPicker
    }

    public init() { }
    public var body: some View {
        @Bindable var appContext = appContext
        
        HStack {
            
            Button(action: {
                appContext.showTonicModeLabelsPopover.toggle()
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
                            Image(systemName: InstrumentChoice.tonicPicker.filledIcon)
                        }
                        if appContext.showModePicker {
                            Image(systemName: InstrumentChoice.modePicker.filledIcon)
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
                        tonicPicker.resetDefaultLabelChoices()
                    }, label: {
                        Image(systemName: "gobackward")
                            .gridCellAnchor(.center)
                            .foregroundColor(tonicPicker.areDefaultLabelChoices ? .gray : .white)
                    })
                    .gridCellColumns(2)
                    .disabled(tonicPicker.areDefaultLabelChoices)
                    .padding([.top, .bottom], 7)
                }
            })
            .transition(.scale)
            
            Button(action: {
                withAnimation {
                    appContext.showTonicPicker.toggle()
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: appContext.showTonicPicker ? InstrumentChoice.tonicPicker.filledIcon : InstrumentChoice.tonicPicker.icon)
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
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: appContext.showModePicker ? InstrumentChoice.modePicker.filledIcon :
                                InstrumentChoice.modePicker.icon)
                        .foregroundColor(.white)
                        .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .onChange(of: appContext.showModePicker) {
                if appContext.showModePicker {
                    tonicPicker.showOutlines = true
                }
            }
        }
    }
}
