import SwiftUI
import HomeyMusicKit

public struct TonicModePickerNotationView: View {
    @Environment(AppContext.self) var appContext
    @Environment(TonalContext.self) var tonalContext
    @Environment(NotationalContext.self) var notationalContext
    @Environment(NotationalTonicContext.self) var notationalTonicContext
    @Environment(InstrumentalContext.self) var instrumentalContext
    
    public init() { }
    public var body: some View {
        @Bindable var appContext = appContext
        @Bindable var notationalTonicContext = notationalTonicContext
        
        HStack {
            
            Button(action: {
                appContext.showTonicModeLabelsPopover.toggle()
            }) {
                Color.clear.overlay(
                    Image(systemName: "tag")
                        .foregroundColor(!(notationalTonicContext.showTonicPicker || notationalTonicContext.showModePicker) ? .gray : .white)
                        .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                )
                .aspectRatio(1.0, contentMode: .fit)
            }
            .disabled(!(notationalTonicContext.showTonicPicker || notationalTonicContext.showModePicker))
            .popover(isPresented: $appContext.showTonicModeLabelsPopover, content: {
                VStack(spacing: 0) {
                    HStack(spacing: 3) {
                        if notationalTonicContext.showTonicPicker {
                            Image(systemName: InstrumentChoice.tonicPicker.filledIcon)
                        }
                        if notationalTonicContext.showModePicker {
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
                        notationalTonicContext.resetLabels()
                    }, label: {
                        Image(systemName: "gobackward")
                            .gridCellAnchor(.center)
                            .foregroundColor(notationalTonicContext.areLabelsDefault(for: InstrumentChoice.tonicPicker) ? .gray : .white)
                    })
                    .gridCellColumns(2)
                    .disabled(notationalTonicContext.areLabelsDefault(for: InstrumentChoice.tonicPicker))
                    .padding([.top, .bottom], 7)
                }
            })
            .transition(.scale)
            
            Button(action: {
                withAnimation {
                    notationalTonicContext.showTonicPicker.toggle()
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: notationalTonicContext.showTonicPicker ? InstrumentChoice.tonicPicker.filledIcon : InstrumentChoice.tonicPicker.icon)
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
                .padding(30.0)
            }
            
            Button(action: {
                withAnimation {
                    notationalTonicContext.showModePicker.toggle()
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: notationalTonicContext.showModePicker ? InstrumentChoice.modePicker.filledIcon :
                                InstrumentChoice.modePicker.icon)
                        .foregroundColor(.white)
                        .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .onChange(of: notationalTonicContext.showModePicker) {
                if notationalTonicContext.showModePicker {
                    notationalContext.outline[instrumentalContext.instrumentChoice] = true
                }
            }
        }
    }
}
