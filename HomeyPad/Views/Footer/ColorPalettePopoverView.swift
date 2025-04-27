import SwiftUI
import SwiftData
import HomeyMusicKit

struct ColorPalettePopoverView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(AppContext.self) var appContext
    @Environment(InstrumentalContext.self) var instrumentalContext
    @Environment(NotationalContext.self) var notationalContext
    
    @Query(
        sort: \IntervalColorPalette.position, order: .forward
    ) var intervalColorPalettes: [IntervalColorPalette]
    
    @Query(
        sort: \PitchColorPalette.position, order: .forward
    ) var pitchColorPalettes: [PitchColorPalette]
    
    var body: some View {
        let instrument = modelContext.instrument(for: instrumentalContext.instrumentChoice)

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
                    ColorPaletteGridRow(listedColorPalette: intervalColorPalette)
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
                    ColorPaletteGridRow(listedColorPalette: pitchColorPalette)
                        .id(pitchColorPalette.id)
                }
                
            }
            .padding(10)
            .onAppear {
                if let selectedPalette = notationalContext.colorPalettes[instrumentalContext.instrumentChoice] {
                    scrollProxy.scrollTo(selectedPalette.id, anchor: .center)
                }
            }
        }
    }
}

struct ColorPaletteGridRow: View {
    let listedColorPalette: ColorPalette
    
    @Environment(InstrumentalContext.self) var instrumentalContext
    @Environment(NotationalContext.self) var notationalContext
    
    var body: some View {
        // 1) Get a binding to the *current* palette for the selected instrument
        let paletteBinding = notationalContext.colorPaletteBinding(for: instrumentalContext.instrumentChoice)
        
        GridRow {
            switch listedColorPalette {
            case let intervalPalette as IntervalColorPalette:
                IntervalColorPaletteImage(intervalColorPalette: intervalPalette)
                    .foregroundColor(.white)
            case let pitchPalette as PitchColorPalette:
                PitchColorPaletteImage(pitchColorPalette: pitchPalette)
                    .foregroundColor(.white)
            default:
                EmptyView()
            }
            
            HStack {
                Text(listedColorPalette.name)
                    .lineLimit(1)
                    .foregroundColor(.white)
                
                Spacer()
                
                // 2) If this listed palette is the same as the binding’s value, show checkmark
                if listedColorPalette.id == paletteBinding.wrappedValue.id {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "checkmark")
                        .foregroundColor(.clear)
                }
            }
        }
        .gridCellAnchor(.leading)
        .contentShape(Rectangle())
        .onTapGesture {
            // 3) When tapping, set the binding’s value to the new palette
            if paletteBinding.wrappedValue.id != listedColorPalette.id {
                buzz()
                // This automatically updates `colorPalettes[instrumentChoice]`
                // and also triggers the "saveColorPaletteIDs()" logic
                paletteBinding.wrappedValue = listedColorPalette
            }
        }
        .padding(3)
    }
}
