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
                TonalContext.shared.shiftDownOneOctave()
            }, label: {
                Image(systemName: "water.waves.and.arrow.down")
                    .foregroundColor(TonalContext.shared.canShiftDownOneOctave() ? .white : Color(UIColor.systemGray4))
            })
            .disabled(!TonalContext.shared.canShiftDownOneOctave())
            
            // Display the octave shift value
            Text(TonalContext.shared.octaveShift.formatted(.number.sign(strategy: .always(includingZero: false))))
                .foregroundColor(.white)
                .fixedSize(horizontal: true, vertical: false)
                .frame(width: 41, alignment: .center)
            
            // Upward octave shift button
            Button(action: {
                TonalContext.shared.shiftUpOneOctave()
            }, label: {
                Image(systemName: "water.waves.and.arrow.up")
                    .foregroundColor(TonalContext.shared.canShiftUpOneOctave() ? .white : Color(UIColor.systemGray4))
            })
            .disabled(!TonalContext.shared.canShiftUpOneOctave())
        }
    }
}
