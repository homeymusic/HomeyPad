import SwiftUI
import HomeyMusicKit

public struct OctaveShiftView: View {
    @Environment(TonalContext.self) var tonalContext
    
    public init() { }
    
    public var body: some View {
        HStack(spacing: 0) {
            // Downward octave shift button
            Button(action: {
                tonalContext.shiftDownOneOctave()
            }, label: {
                Color.clear.overlay(
                    Image(systemName: "water.waves.and.arrow.down")
                        .foregroundColor(tonalContext.canShiftDownOneOctave ? .white : Color.systemGray4)
                )
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 44)
            })
            .disabled(!tonalContext.canShiftDownOneOctave)
            
            divider
            
            // Display the octave shift value
            Text(tonalContext.octaveShift.formatted(.number.sign(strategy: .always(includingZero: false))))
                .foregroundColor(.white)
                .fixedSize(horizontal: true, vertical: false)
                .frame(width: 44)
            
            divider
            
            // Upward octave shift button
            Button(action: {
                tonalContext.shiftUpOneOctave()
            }, label: {
                Color.clear.overlay(
                    Image(systemName: "water.waves.and.arrow.up")
                        .foregroundColor(tonalContext.canShiftUpOneOctave ? .white : Color.systemGray4)
                )
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 44)
            })
            .disabled(!tonalContext.canShiftUpOneOctave)
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
