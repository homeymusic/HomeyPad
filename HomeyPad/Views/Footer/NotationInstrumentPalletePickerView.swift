import SwiftUI
import HomeyMusicKit

public struct NotationInstrumentPalletePickerView: View {
    @Environment(\.modelContext) private var modelContext

    @Environment(TonalContext.self) var tonalContext
    @Environment(InstrumentalContext.self) var instrumentalContext
    @Environment(NotationalContext.self) var notationalContext
    
    private var instrument: any Instrument {
        modelContext.instrument(for: instrumentalContext.instrumentChoice)
    }

    public init() { }
    
    public var body: some View {
        @Bindable var notationalContext = notationalContext
        @Bindable var instrumentalContext = instrumentalContext
        
        Group {
            
            Button(action: {
                notationalContext.showLabelsPopover.toggle()
            }) {
                ZStack {
                    Image(systemName: "tag")
                        .foregroundColor(.white)
                        .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                        .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .popover(isPresented: $notationalContext.showLabelsPopover, content: {
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
                    get: { instrumentalContext.instrumentChoice },
                    set: { newValue in
                        instrumentalContext.instrumentChoice = newValue
                    }
                )) {
                    ForEach(InstrumentChoice.keyboardInstruments + [instrumentalContext.stringInstrumentChoice], id:\.self) { instrument in
                        Image(systemName: instrument.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 160, maxWidth: .infinity)
                            .tag(instrument)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: instrumentalContext.instrumentChoice) {
                    notationalContext.showColorPalettePopover = false
                    notationalContext.showEditColorPaletteSheet = false
                    notationalContext.showLabelsPopover = false
                }
            }
            
            Button(action: {
                notationalContext.showColorPalettePopover.toggle()
                notationalContext.showEditColorPaletteSheet = false
            }) {
                ZStack {
                    Image(systemName: "paintpalette")
                        .foregroundColor(.white)
                        .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                        .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .popover(isPresented: $notationalContext.showColorPalettePopover,
                     content: {
                VStack(spacing: 0) {
                    Image(systemName: instrumentalContext.instrumentChoice.icon)
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
                                notationalContext.showEditColorPaletteSheet = true
                            })
#if !os(macOS)
                            .fullScreenCover(isPresented: $notationalContext.showEditColorPaletteSheet) {
                                ColorPaletteManagerView()
                                    .background(Color.systemGray6)
                                    .scrollContentBackground(.hidden)
                            }
#else
                            .sheet(isPresented: $notationalContext.showEditColorPaletteSheet) {
                                ColorPaletteManagerView()
                            }
#endif
                            .padding([.top, .bottom], 7)
                            .padding(.trailing, 7)
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                notationalContext.resetColorPalette(for: instrumentalContext.instrumentChoice)
                            }, label: {
                                Image(systemName: "gobackward")
                                    .foregroundColor(notationalContext.isColorPaletteDefault(for: instrumentalContext.instrumentChoice) ? .gray : .white)
                            })
                            .padding([.top, .bottom], 7)
                            .disabled(notationalContext.isColorPaletteDefault(for: instrumentalContext.instrumentChoice))
                            Spacer()
                        }
                    }
                }
            })
            .padding(.leading, 5)
        }
    }
}
