import SwiftUI
import SwiftData
import HomeyMusicKit

struct ColorPalettePopoverView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(AppContext.self) var appContext
    
    @Query(
        sort: \IntervalColorPalette.position, order: .forward
    ) var intervalColorPalettes: [IntervalColorPalette]
    
    @Query(
        sort: \PitchColorPalette.position, order: .forward
    ) var pitchColorPalettes: [PitchColorPalette]
    
    var body: some View {
        let instrument = modelContext.instrument(for: appContext.instrumentChoice)

        // 2) Create a Binding<Bool> for showOutlines
        let showOutlinesBinding = Binding<Bool>(
          get: { instrument.showOutlines },
          set: { newValue in
            try? modelContext.transaction {
              instrument.showOutlines = newValue
            }
          }
        )

        ScrollViewReader { scrollProxy in
            Grid {
                
                ForEach(intervalColorPalettes, id: \.self) {intervalColorPalette in
                    ColorPaletteGridRow(colorPalette: intervalColorPalette)
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
                    .onChange(of: instrument.showOutlines) {
                        buzz()
                        if instrument.showOutlines == false {
                            withAnimation {
                                appContext.showModePicker = false
                            }
                        }
                    }
                }
                
                Divider()
                
                ForEach(pitchColorPalettes, id: \.self) {pitchColorPalette in
                    ColorPaletteGridRow(colorPalette: pitchColorPalette)
                        .id(pitchColorPalette.id)
                }
                
            }
            .padding(10)
            .onAppear {
                let selectedPalette = instrument.colorPalette
                scrollProxy.scrollTo(selectedPalette.id, anchor: .center)
            }
        }
    }
}

struct ColorPaletteGridRow: View {
    /// A single palette (either IntervalColorPalette or PitchColorPalette)
    let colorPalette: ColorPalette

    @Environment(\.modelContext)           private var modelContext
    @Environment(AppContext.self) var appContext


    var body: some View {
        // 1) Fetch the exact instrument model we’re editing
        let instrument = modelContext.instrument(
            for: appContext.instrumentChoice
        )

        // 2) Compute whether *this* palette is currently assigned to that instrument
        let isColorPaletteSelected: Bool = {
            switch colorPalette {
            case let intervalColorPalette as IntervalColorPalette:
                return instrument.intervalColorPalette?.id
                    == intervalColorPalette.id

            case let pitchColorPalette as PitchColorPalette:
                return instrument.pitchColorPalette?.id
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
                    instrument.intervalColorPalette = intervalColorPalette
                    instrument.pitchColorPalette    = nil
                    
                case let pitchColorPalette as PitchColorPalette:
                    instrument.pitchColorPalette = pitchColorPalette
                    instrument.intervalColorPalette = nil

                default:
                    break
                }
            }
            buzz()
        }
        .padding(3)
    }
}
