import SwiftUI
import SwiftData
import HomeyMusicKit

public struct NotationInstrumentPalletePickerView: View {
    @Environment(\.modelContext) private var modelContext

    @Environment(AppContext.self) var appContext
    @Query(sort: \IntervalColorPalette.position) private var intervalColorPalettes: [IntervalColorPalette]

    private var instrument: any MusicalInstrument {
        modelContext.singletonInstrument(for: appContext.instrumentType)
    }
    private var tonicPicker: TonicPicker {
        modelContext.singletonInstrument(for: .tonicPicker) as! TonicPicker
    }

    public init() { }
    
    public var body: some View {
        @Bindable var appContext = appContext
        
        Group {
            
            Button(action: {
                appContext.showLabelsPopover.toggle()
                buzz()
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
                    Image(systemName: instrument.instrumentType.icon)
                        .padding([.top, .bottom], 7)
                    Divider()
                    ScrollView(.vertical) {
                        NotationPopoverView()
                            .presentationCompactAdaptation(.none)
                    }
                    Divider()
                    Button(action: {
                        instrument.resetDefaultLabelTypes()
                        buzz()
                    }, label: {
                        Image(systemName: "gobackward")
                            .foregroundColor(instrument.areDefaultLabelTypes ? .gray : .white)
                    })
                    .padding([.top, .bottom], 7)
                    .disabled(instrument.areDefaultLabelTypes)
                }
            })
            .padding(.trailing, 5)
            
            HStack {
                Picker("", selection: Binding(
                    get: { appContext.instrumentType },
                    set: { newInstrumentType in
                        // 1️⃣ Fetch the “old” and the “new” instrument
                        let oldInstrument = modelContext.singletonInstrument(for: appContext.instrumentType)
                        let newInstrument = modelContext.singletonInstrument(for: newInstrumentType)
                        
                        if oldInstrument.latching && newInstrument.latching {
                            appContext.latchedMIDINoteNumbers  = oldInstrument.tonality.activatedPitches.map { $0.midiNote.number }
                        } else {
                            oldInstrument.deactivateAllMIDINoteNumbers()
                        }
                        if appContext.showModePicker {
                            tonicPicker.showOutlines = true
                        }
                        tonicPicker.showModeOutlines = appContext.showModePicker
                        newInstrument.showModeOutlines = appContext.showModePicker

                        appContext.instrumentType = newInstrumentType
                    }
                )) {
                    ForEach(InstrumentType.keyboardInstruments + [appContext.stringInstrumentType], id:\.self) { instrument in
                        Image(systemName: instrument.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 160, maxWidth: .infinity)
                            .tag(instrument)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: appContext.instrumentType) {
                    appContext.showColorPalettePopover = false
                    appContext.showEditColorPaletteSheet = false
                    appContext.showLabelsPopover = false
                    buzz()
                }
            }
            
            Button(action: {
                appContext.showColorPalettePopover.toggle()
                appContext.showEditColorPaletteSheet = false
                buzz()
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
                    Image(systemName: appContext.instrumentType.icon)
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
                                buzz()
                            })
#if !os(macOS)
                            .fullScreenCover(isPresented: $appContext.showEditColorPaletteSheet) {
                                ColorPaletteManagerView(instrument: instrument)
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
                                instrument.colorPalette = defaultColorPalette
                                tonicPicker.colorPalette = defaultColorPalette
                                instrument.showOutlines = true
                                tonicPicker.showOutlines = true
                                buzz()
                            }, label: {
                                Image(systemName: "gobackward")
                                    .foregroundColor(isDefaultColorPalette ? .gray : .white)
                            })
                            .disabled(isDefaultColorPalette)
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
    
    var defaultColorPalette: IntervalColorPalette {
        (intervalColorPalettes.first ?? IntervalColorPalette.homey)
    }

    var isDefaultColorPalette: Bool {
        (defaultColorPalette == (instrument.colorPalette as? IntervalColorPalette)) &&
        instrument.showOutlines == true
    }
}
