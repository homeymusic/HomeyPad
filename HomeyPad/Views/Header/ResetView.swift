import SwiftUI
import HomeyMusicKit

struct ResetView: View {
    @Bindable public var tonalityInstrument: TonalityInstrument

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                tonalityInstrument.resetTonality()
                buzz()
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: "gobackward")
                            .foregroundColor(tonalityInstrument.isDefaultTonality ? .gray : .white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .transition(.scale)
            .disabled(tonalityInstrument.isDefaultTonality)
        }
    }
}
