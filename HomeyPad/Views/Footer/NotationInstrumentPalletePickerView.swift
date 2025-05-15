import SwiftUI
import SwiftData
import HomeyMusicKit

public struct NotationInstrumentPalletePickerView: View {
    @Bindable public var tonalityInstrument: TonalityInstrument
    
    @Environment(\.modelContext) private var modelContext
    @Environment(AppContext.self) var appContext
    @Query(sort: \IntervalColorPalette.position) private var intervalColorPalettes: [IntervalColorPalette]

    @Environment(SynthConductor.self) private var synthConductor
    @Environment(MIDIConductor.self)  private var midiConductor

    private var musicalInstrument: MusicalInstrument {
        modelContext.singletonInstrument(
            for: appContext.instrumentType,
            midiConductor: midiConductor,
            synthConductor: synthConductor
        )
    }

    public var body: some View {
        @Bindable var appContext = appContext
        
        Group {
            
            Button(action: {
                appContext.showLabelsPopover.toggle()
                buzz()
            }) {
                ZStack {
                    Image(systemName: appContext.showLabelsPopover ? "tag.fill" : "tag")
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
                        musicalInstrument.resetDefaultLabelTypes()
                        buzz()
                    }, label: {
                        Image(systemName: "gobackward")
                            .foregroundColor(musicalInstrument.areDefaultLabelTypes ? .gray : .white)
                    })
                    .padding([.top, .bottom], 7)
                    .disabled(musicalInstrument.areDefaultLabelTypes)
                }
            })
            .padding(.trailing, 5)
            
            HStack {
                Picker("", selection: Binding(
                    get: { appContext.instrumentType },
                    set: { newMusicalInstrumentType in
                        let oldInstrument = modelContext.singletonInstrument(
                            for: appContext.instrumentType,
                            midiConductor: midiConductor,
                            synthConductor: synthConductor
                        )
                        let newInstrument = modelContext.singletonInstrument(
                            for: newMusicalInstrumentType,
                            midiConductor: midiConductor,
                            synthConductor: synthConductor
                        )
                        
                        if oldInstrument.latching && newInstrument.latching {
                            appContext.latchedMIDINoteNumbers  = oldInstrument.activatedPitches.map { $0.midiNote.number }
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
                    ForEach(MIDIInstrumentType.keyboardInstruments + [appContext.stringMusicalInstrumentType], id:\.self) { instrument in
                        
                        let iconName = instrument == appContext.instrumentType
                            ? instrument.filledIcon
                            : instrument.icon

                        Image(systemName: iconName)
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
                    Image(systemName: appContext.showColorPalettePopover ? "paintpalette.fill" : "paintpalette")
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
                                ColorPaletteManagerView(instrument: musicalInstrument)
                                    .background(Color.systemGray6)
                                    .scrollContentBackground(.hidden)
                            }
#else
                            .sheet(isPresented: $appContext.showEditColorPaletteSheet) {
                                ColorPaletteManagerView(instrument: musicalInstrument)
                            }
#endif
                            .padding([.top, .bottom], 7)
                            .padding(.trailing, 7)
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                musicalInstrument.colorPalette = defaultColorPalette
                                tonalityInstrument.colorPalette = defaultColorPalette
                                musicalInstrument.showOutlines = true
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
        (defaultColorPalette == (musicalInstrument.colorPalette as? IntervalColorPalette)) &&
        musicalInstrument.showOutlines == true
    }
}
