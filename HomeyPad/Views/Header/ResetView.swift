import SwiftUI
import HomeyMusicKit

struct ResetView: View {
    @Environment(InstrumentalContext.self) var instrumentalContext
    @Environment(TonalContext.self) var tonalContext

    var body: some View {
        
        @Bindable var instrumentalContext = instrumentalContext
        @Bindable var tonalContext = tonalContext
        
        HStack(spacing: 0) {
            Button(action: {
                instrumentalContext.resetTonalContext(tonalContext: tonalContext)
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: "gobackward")
                            .foregroundColor(tonalContext.isDefault ? .gray : .accentColor)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .transition(.scale)
            .disabled(tonalContext.isDefault)
        }
    }
}


