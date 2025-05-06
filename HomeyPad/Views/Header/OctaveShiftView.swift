import SwiftUI
import HomeyMusicKit

public struct OctaveShiftView: View {
    @Bindable public var tonality: Tonality
    @Bindable public var tonalityInstrument: TonalityInstrument

    public var body: some View {
        HStack(spacing: 0) {
            // Downward octave shift button
            Button(action: {
                tonalityInstrument.shiftDownOneOctave()
                buzz()
            }, label: {
                Color.clear.overlay(
                    Image(systemName: "water.waves.and.arrow.down")
                        .foregroundColor(tonality.canShiftDownOneOctave ? .white : Color.systemGray4)
                )
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 44)
            })
            .disabled(!tonality.canShiftDownOneOctave)
            
            divider
            
            // Display the octave shift value
            Text(tonality.octaveShiftStatus.formatted(.number.sign(strategy: .always(includingZero: false))))
                .foregroundColor(.white)
                .fixedSize(horizontal: true, vertical: false)
                .frame(width: 44)
            
            divider
            
            // Upward octave shift button
            Button(action: {
                tonalityInstrument.shiftUpOneOctave()
                buzz()
            }, label: {
                Color.clear.overlay(
                    Image(systemName: "water.waves.and.arrow.up")
                        .foregroundColor(tonality.canShiftUpOneOctave ? .white : Color.systemGray4)
                )
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 44)
            })
            .disabled(!tonality.canShiftUpOneOctave)
        }
        .background(Color.systemGray6)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var divider: some View {
        Rectangle()
            .fill(Color.systemGray4)
            .frame(width: 1, height: 17.5)
    }
}
