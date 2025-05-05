import SwiftUI
import SwiftData
import HomeyMusicKit

public struct NotationInstrumentPalletePickerView: View {
    @Bindable public var tonalityInstrument: TonalityInstrument
    
    @Environment(\.modelContext) private var modelContext
    @Environment(AppContext.self) var appContext
    @Query(sort: \IntervalColorPalette.position) private var intervalColorPalettes: [IntervalColorPalette]

    private var instrument: any MusicalInstrument {
        modelContext.singletonInstrument(for: appContext.instrumentType)
    }

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
                    Image(systemName: appContext.instrumentType.icon)
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
                    set: { newMusicalInstrumentType in
                        // 1️⃣ Fetch the “old” and the “new” instrument
                        let oldInstrument = modelContext.singletonInstrument(for: appContext.instrumentType)
                        let newInstrument = modelContext.singletonInstrument(for: newMusicalInstrumentType)
                        
                        if oldInstrument.latching && newInstrument.latching {
                            appContext.latchedMIDINoteNumbers  = oldInstrument.tonality.activatedPitches.map { $0.midiNote.number }
                        } else {
                            oldInstrument.deactivateAllMIDINoteNumbers()
                        }
                        if tonalityInstrument.showModePicker {
                            tonalityInstrument.showOutlines = true
                        }
                        tonalityInstrument.showModeOutlines = tonalityInstrument.showModePicker
                        newInstrument.showModeOutlines = tonalityInstrument.showModePicker

                        appContext.instrumentType = newMusicalInstrumentType
                    }
                )) {
                    ForEach(MusicalInstrumentType.keyboardInstruments + [appContext.stringMusicalInstrumentType], id:\.self) { instrument in
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
                        ColorPalettePopoverView(tonalityInstrument: tonalityInstrument)
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
                                ColorPaletteManagerView(instrument: instrument)
                            }
#endif
                            .padding([.top, .bottom], 7)
                            .padding(.trailing, 7)
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                instrument.colorPalette = defaultColorPalette
                                tonalityInstrument.colorPalette = defaultColorPalette
                                instrument.showOutlines = true
                                tonalityInstrument.showOutlines = true
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
