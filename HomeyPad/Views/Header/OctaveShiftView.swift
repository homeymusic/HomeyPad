import SwiftUI
import HomeyMusicKit

struct OctaveShiftView: View {
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var tonicConductor: ViewConductor
    @StateObject private var tonalContext = TonalContext.shared

    var body: some View {
        HStack(spacing: 5) {
            // Downward octave shift button
            Button(action: {
                tonalContext.shiftTonicDownOneOctave()
            }, label: {
                Image(systemName: "water.waves.and.arrow.down")
                    .foregroundColor(tonalContext.tonicPitch.canShiftDownOneOctave ? .white : Color(UIColor.systemGray4))
            })
            .disabled(!tonalContext.tonicPitch.canShiftDownOneOctave)
            
            // Display the octave shift value
            Text(TonalContext.shared.octaveShift.formatted(.number.sign(strategy: .always(includingZero: false))))
                .foregroundColor(.white)
                .fixedSize(horizontal: true, vertical: false)
                .frame(width: 41, alignment: .center)
            
            // Upward octave shift button
            Button(action: {
                tonalContext.shiftTonicUpOneOctave()
            }, label: {
                Image(systemName: "water.waves.and.arrow.up")
                    .foregroundColor(tonalContext.tonicPitch.canShiftUpOneOctave ? .white : Color(UIColor.systemGray4))
            })
            .disabled(!tonalContext.tonicPitch.canShiftUpOneOctave)
        }
    }
}
