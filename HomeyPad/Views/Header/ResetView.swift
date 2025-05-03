import SwiftUI
import HomeyMusicKit

struct ResetView: View {
    let instrument: MusicalInstrument
    
    public init(instrument: MusicalInstrument) { self.instrument = instrument}

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                instrument.tonality.resetTonality()
                buzz()
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: "gobackward")
                            .foregroundColor(instrument.tonality.isDefaultTonality ? .gray : .white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .transition(.scale)
            .disabled(instrument.tonality.isDefaultTonality)
        }
    }
}
