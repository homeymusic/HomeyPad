import SwiftUI
import HomeyMusicKit

struct OctaveShiftView: View {
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var tonicConductor: ViewConductor

    var body: some View {
        HStack(spacing: 5) {
            // Downward octave shift button
            Button(action: {
                tonicConductor.tonalContext.shiftDownOneOctave()
            }, label: {
                Image(systemName: "water.waves.and.arrow.down")
                    .foregroundColor(tonicConductor.tonalContext.canShiftDownOneOctave ? .white : Color(UIColor.systemGray4))
            })
            .disabled(!tonicConductor.tonalContext.canShiftDownOneOctave)
            
            // Display the octave shift value
            Text(tonicConductor.tonalContext.octaveShift.formatted(.number.sign(strategy: .always(includingZero: false))))
                .foregroundColor(.white)
                .fixedSize(horizontal: true, vertical: false)
                .frame(width: 41, alignment: .center)
            
            // Upward octave shift button
            Button(action: {
                tonicConductor.tonalContext.shiftUpOneOctave()
            }, label: {
                Image(systemName: "water.waves.and.arrow.up")
                    .foregroundColor(tonicConductor.tonalContext.canShiftUpOneOctave ? .white : Color(UIColor.systemGray4))
            })
            .disabled(!tonicConductor.tonalContext.canShiftUpOneOctave)
        }
    }
}
