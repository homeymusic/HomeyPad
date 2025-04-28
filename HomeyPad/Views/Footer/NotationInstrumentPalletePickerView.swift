import SwiftUI
import HomeyMusicKit

public struct NotationInstrumentPalletePickerView: View {
    @Environment(\.modelContext) private var modelContext

    @Environment(AppContext.self) var appContext
    
    private var instrument: any Instrument {
        modelContext.instrument(for: appContext.instrumentChoice)
    }

    public init() { }
    
    public var body: some View {
        @Bindable var appContext = appContext
        
        Group {
            
            Button(action: {
                appContext.showLabelsPopover.toggle()
            }) {
                ZStack {
                    Image(systemName: "tag")
                        .foregroundColor(.white)
                        .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                        .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .popover(isPresented: $appContext.showLabelsPopover, content: {
                VStack(spacing: 0) {
                    Image(systemName: instrument.instrumentChoice.icon)
                        .padding([.top, .bottom], 7)
                    Divider()
                    ScrollView(.vertical) {
                        NotationPopoverView()
                            .presentationCompactAdaptation(.none)
                    }
                    Divider()
                    Button(action: {
                        instrument.resetDefaultLabelChoices()
                        buzz()
                    }, label: {
                        Image(systemName: "gobackward")
                            .foregroundColor(instrument.areDefaultLabelChoices ? .gray : .white)
                    })
                    .padding([.top, .bottom], 7)
                    .disabled(instrument.areDefaultLabelChoices)
                }
            })
            .padding(.trailing, 5)
            
            HStack {
                Picker("", selection: Binding(
                    get: { appContext.instrumentChoice },
                    set: { newValue in
                        appContext.instrumentChoice = newValue
                    }
                )) {
                    ForEach(InstrumentChoice.keyboardInstruments + [appContext.stringInstrumentChoice], id:\.self) { instrument in
                        Image(systemName: instrument.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 160, maxWidth: .infinity)
                            .tag(instrument)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: appContext.instrumentChoice) {
                    appContext.showColorPalettePopover = false
                    appContext.showEditColorPaletteSheet = false
                    appContext.showLabelsPopover = false
                }
            }
            
            Button(action: {
                appContext.showColorPalettePopover.toggle()
                appContext.showEditColorPaletteSheet = false
            }) {
                ZStack {
                    Image(systemName: "paintpalette")
                        .foregroundColor(.white)
                        .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                        .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .popover(isPresented: $appContext.showColorPalettePopover,
                     content: {
                VStack(spacing: 0) {
                    Image(systemName: appContext.instrumentChoice.icon)
                        .padding([.top, .bottom], 7)
                    Divider()
                    ScrollView(.vertical) {
                        ColorPalettePopoverView()
                            .presentationCompactAdaptation(.none)
                    }
                    Divider()
                    ZStack {
                        HStack {
                            Spacer()
                            Button("", systemImage: "paintbrush.pointed", action: {
                                appContext.showEditColorPaletteSheet = true
                            })
#if !os(macOS)
                            .fullScreenCover(isPresented: $appContext.showEditColorPaletteSheet) {
                                ColorPaletteManagerView()
                                    .background(Color.systemGray6)
                                    .scrollContentBackground(.hidden)
                            }
#else
                            .sheet(isPresented: $appContext.showEditColorPaletteSheet) {
                                ColorPaletteManagerView()
                            }
#endif
                            .padding([.top, .bottom], 7)
                            .padding(.trailing, 7)
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                instrument.intervalColorPalette = IntervalColorPalette.homey
                            }, label: {
                                Image(systemName: "gobackward")
                                    .foregroundColor(false ? .gray : .white)
                            })
                            .padding([.top, .bottom], 7)
                            .disabled(false)
                            Spacer()
                        }
                    }
                }
            })
            .padding(.leading, 5)
        }
    }
}
