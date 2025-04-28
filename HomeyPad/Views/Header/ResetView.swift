import SwiftUI
import HomeyMusicKit

struct ResetView: View {
    let instrument: Instrument
    
    public init(instrument: Instrument) { self.instrument = instrument}

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                instrument.resetTonality()
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: "gobackward")
                            .foregroundColor(instrument.isDefaultTonality ? .gray : .white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .transition(.scale)
            .disabled(instrument.isDefaultTonality)
        }
    }
}
