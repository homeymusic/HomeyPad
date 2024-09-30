import SwiftUI
import HomeyMusicKit

struct OctaveShiftView: View {
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var tonicConductor: ViewConductor
    
    var body: some View {
        HStack(spacing: 5) {
            let newDownwardTonicMIDI = tonicConductor.tonicMIDI - 12
            Button(action: {
                tonicConductor.tonicMIDI = newDownwardTonicMIDI
                viewConductor.tonicMIDI = tonicConductor.tonicMIDI
                Task { @MainActor in
                    buzz()
                }
            }, label: {
                Image(systemName: "water.waves.and.arrow.down")
                    .foregroundColor(safeMIDI(midi: newDownwardTonicMIDI) ? .white : Color(UIColor.systemGray4))
            })
            .disabled(!safeMIDI(midi: newDownwardTonicMIDI))
            
            Text(tonicConductor.octaveShift.formatted(.number.sign(strategy: .always(includingZero: false))))
                .foregroundColor(.white)
                .fixedSize(horizontal: true, vertical: false)
                .frame(width: 41, alignment: .center)
            
            let newUpwardTonicMIDI = tonicConductor.tonicMIDI + 12
            Button(action: {
                tonicConductor.tonicMIDI = newUpwardTonicMIDI
                viewConductor.tonicMIDI = tonicConductor.tonicMIDI
                buzz()
            }, label: {
                Image(systemName: "water.waves.and.arrow.up")
                    .foregroundColor(safeMIDI(midi: newUpwardTonicMIDI) ? .white : Color(UIColor.systemGray4))
            })
            .disabled(!safeMIDI(midi: newUpwardTonicMIDI))
        }
    }
}


