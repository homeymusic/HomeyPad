import SwiftUI
import SwiftData
import HomeyMusicKit

struct ColorPalettePopoverView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(AppContext.self) var appContext
    
    @Bindable public var tonalityInstrument: TonalityInstrument

    @Query(
        sort: \IntervalColorPalette.position, order: .forward
    ) var intervalColorPalettes: [IntervalColorPalette]
    
    @Query(
        sort: \PitchColorPalette.position, order: .forward
    ) var pitchColorPalettes: [PitchColorPalette]
    
    @Environment(SynthConductor.self) private var synthConductor
    @Environment(MIDIConductor.self)  private var midiConductor

    private var musicalInstrument: MusicalInstrument {
        modelContext.singletonInstrument(
            for: appContext.instrumentType,
            midiConductor: midiConductor,
            synthConductor: synthConductor
        )
    }

    var body: some View {
        
        // 2) Create a Binding<Bool> for showOutlines
        let showOutlinesBinding = Binding<Bool>(
            get: { musicalInstrument.showOutlines },
            set: { newValue in
                try? modelContext.transaction {
                    musicalInstrument.showOutlines = newValue
                    tonalityInstrument.showOutlines = newValue
                }
            }
        )
        
        ScrollViewReader { scrollProxy in
            Grid {
                
                ForEach(intervalColorPalettes, id: \.self) {intervalColorPalette in
                    ColorPaletteGridRow(tonalityInstrument: tonalityInstrument, colorPalette: intervalColorPalette)
                        .id(intervalColorPalette.id)
                }
                
                Divider()
                
                GridRow {
                    Image(systemName: "pencil.and.outline")
                        .gridCellAnchor(.center)
                        .foregroundColor(.white)
                    Toggle(
                        "Outline",
                        isOn: showOutlinesBinding
                    )
                    .tint(Color.gray)
                    .foregroundColor(.white)
                    .onChange(of: musicalInstrument.showOutlines) {
                        buzz()
                        if musicalInstrument.showOutlines == false {
                            withAnimation {
                                tonalityInstrument.showModePicker = false
                            }
                        }
                    }
                }
                
                Divider()
                
                ForEach(pitchColorPalettes, id: \.self) {pitchColorPalette in
                    ColorPaletteGridRow(tonalityInstrument: tonalityInstrument, colorPalette: pitchColorPalette)
                        .id(pitchColorPalette.id)
                }
                
            }
            .padding(10)
            .onAppear {
                let selectedPalette = musicalInstrument.colorPalette
                scrollProxy.scrollTo(selectedPalette.id, anchor: .center)
            }
        }
    }
}

struct ColorPaletteGridRow: View {
    @Bindable public var tonalityInstrument: TonalityInstrument

    let colorPalette: ColorPalette
    
    @Environment(\.modelContext)           private var modelContext
    @Environment(AppContext.self) var appContext
    
    @Environment(SynthConductor.self) private var synthConductor
    @Environment(MIDIConductor.self)  private var midiConductor

    private var musicalInstrument: MusicalInstrument {
        modelContext.singletonInstrument(
            for: appContext.instrumentType,
            midiConductor: midiConductor,
            synthConductor: synthConductor
        )
    }
    
    var body: some View {
        
        // 2) Compute whether *this* palette is currently assigned to that instrument
        let isColorPaletteSelected: Bool = {
            switch colorPalette {
            case let intervalColorPalette as IntervalColorPalette:
                return musicalInstrument.intervalColorPalette?.id
                == intervalColorPalette.id
                
            case let pitchColorPalette as PitchColorPalette:
                return musicalInstrument.pitchColorPalette?.id
                == pitchColorPalette.id
                
            default:
                return false
            }
        }()
        
        GridRow {
            // 3) Render the thumbnail image
            switch colorPalette {
            case let intervalColorPalette as IntervalColorPalette:
                IntervalColorPaletteImage(
                    intervalColorPalette: intervalColorPalette
                )
                .foregroundColor(.white)
                
            case let pitchColorPalette as PitchColorPalette:
                PitchColorPaletteImage(
                    pitchColorPalette: pitchColorPalette
                )
                .foregroundColor(.white)
                
            default:
                EmptyView()
            }
            
            // 4) Name + checkmark
            HStack {
                Text(colorPalette.name)
                    .lineLimit(1)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "checkmark")
                    .foregroundColor(
                        isColorPaletteSelected ? .white : .clear
                    )
            }
        }
        .gridCellAnchor(.leading)
        .contentShape(Rectangle())
        .onTapGesture {
            // 5) When tapped, write the new palette into the instrument
            try? modelContext.transaction {
                switch colorPalette {
                case let intervalColorPalette as IntervalColorPalette:
                    musicalInstrument.colorPalette = intervalColorPalette
                    tonalityInstrument.colorPalette = intervalColorPalette

                case let pitchColorPalette as PitchColorPalette:
                    musicalInstrument.colorPalette = pitchColorPalette
                    tonalityInstrument.colorPalette = pitchColorPalette

                default:
                    break
                }
            }
            buzz()
        }
        .padding(3)
    }
}
