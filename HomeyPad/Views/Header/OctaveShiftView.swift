import SwiftUI
import HomeyMusicKit

struct OctaveShiftView: View {
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var tonicConductor: ViewConductor
    
    var body: some View {
        HStack(spacing: 5) {
            let newDownwardTonicMIDI = tonicConductor.tonicPitch.midi - 12
            Button(action: {
                tonicConductor.tonicPitch.midi = newDownwardTonicMIDI
                viewConductor.tonicPitch.midi = tonicConductor.tonicPitch.midi
                Task { @MainActor in
                    buzz()
                }
            }, label: {
                Image(systemName: "water.waves.and.arrow.down")
                    .foregroundColor(safeMIDI(midi: Int(newDownwardTonicMIDI)) ? .white : Color(UIColor.systemGray4))
            })
            .disabled(!safeMIDI(midi: Int(newDownwardTonicMIDI)))
            
            Text(tonicConductor.octaveShift.formatted(.number.sign(strategy: .always(includingZero: false))))
                .foregroundColor(.white)
                .fixedSize(horizontal: true, vertical: false)
                .frame(width: 41, alignment: .center)
            
            let newUpwardTonicMIDI = tonicConductor.tonicMIDI + 12
            Button(action: {
                tonicConductor.tonicPitch.midi = newUpwardTonicMIDI
                viewConductor.tonicPitch.midi = tonicConductor.tonicMIDI
                buzz()
            }, label: {
                Image(systemName: "water.waves.and.arrow.up")
                    .foregroundColor(safeMIDI(midi: Int(newUpwardTonicMIDI)) ? .white : Color(UIColor.systemGray4))
            })
            .disabled(!safeMIDI(midi: Int(newUpwardTonicMIDI)))
        }
    }
}


