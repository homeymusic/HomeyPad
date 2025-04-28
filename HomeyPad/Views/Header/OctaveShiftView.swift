import SwiftUI
import HomeyMusicKit

public struct OctaveShiftView: View {
    let instrument: Instrument
    
    public init(instrument: Instrument) { self.instrument = instrument}
    
    public var body: some View {
        HStack(spacing: 0) {
            // Downward octave shift button
            Button(action: {
                instrument.shiftDownOneOctave()
            }, label: {
                Color.clear.overlay(
                    Image(systemName: "water.waves.and.arrow.down")
                        .foregroundColor(instrument.canShiftDownOneOctave ? .white : Color.systemGray4)
                )
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 44)
            })
            .disabled(!instrument.canShiftDownOneOctave)
            
            divider
            
            // Display the octave shift value
            Text(instrument.octaveShift.formatted(.number.sign(strategy: .always(includingZero: false))))
                .foregroundColor(.white)
                .fixedSize(horizontal: true, vertical: false)
                .frame(width: 44)
            
            divider
            
            // Upward octave shift button
            Button(action: {
                instrument.shiftUpOneOctave()
            }, label: {
                Color.clear.overlay(
                    Image(systemName: "water.waves.and.arrow.up")
                        .foregroundColor(instrument.canShiftUpOneOctave ? .white : Color.systemGray4)
                )
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 44)
            })
            .disabled(!instrument.canShiftUpOneOctave)
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
