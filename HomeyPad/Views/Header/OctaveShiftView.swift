import SwiftUI
import HomeyMusicKit

struct OctaveShiftView: View {
    @ObservedObject var tonicConductor: ViewConductor
    @ObservedObject var tonalContext: TonalContext

    var body: some View {
        HStack(spacing: 5) {
            // Downward octave shift button
            Button(action: {
                tonalContext.shiftDownOneOctave()
            }, label: {
                Image(systemName: "water.waves.and.arrow.down")
                    .foregroundColor(tonalContext.canShiftDownOneOctave ? .white : Color(UIColor.systemGray4))
            })
            .disabled(!tonalContext.canShiftDownOneOctave)
            
            // Display the octave shift value
            Text(tonalContext.octaveShift.formatted(.number.sign(strategy: .always(includingZero: false))))
                .foregroundColor(.white)
                .fixedSize(horizontal: true, vertical: false)
                .frame(width: 41, alignment: .center)
            
            // Upward octave shift button
            Button(action: {
                tonalContext.shiftUpOneOctave()
            }, label: {
                Image(systemName: "water.waves.and.arrow.up")
                    .foregroundColor(tonalContext.canShiftUpOneOctave ? .white : Color(UIColor.systemGray4))
            })
            .disabled(!tonalContext.canShiftUpOneOctave)
        }
    }
}
