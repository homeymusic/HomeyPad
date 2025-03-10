import SwiftUI
import HomeyMusicKit

struct PalettePopoverView: View {
    @EnvironmentObject var tonalContext: TonalContext
    @EnvironmentObject var instrumentalContext: InstrumentalContext
    @EnvironmentObject var notationalContext: NotationalContext
    
    var body: some View {
        VStack(spacing: 10.0) {
            
            Picker("", selection: notationalContext.colorPaletteBinding(for: instrumentalContext.instrumentType)) {
                ForEach(ColorPaletteChoice.allCases, id: \.self) { paletteChoice in
                    Image(systemName: paletteChoice.icon)
                        .tag(paletteChoice)
                }
            }
            .pickerStyle(.segmented)
            
            Grid {
                GridRow {
                    Image(systemName: "pencil.and.outline")
                        .gridCellAnchor(.center)
                        .foregroundColor(.white)
                    Toggle(LayoutPalette.outlineLabel,
                           isOn: notationalContext.outlineBinding(for: instrumentalContext.instrumentType))
                    .tint(Color.gray)
                    .foregroundColor(.white)
                }
            }
        }
        .padding(10)
    }
}
