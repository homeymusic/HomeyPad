import SwiftUI

struct OctaveShiftPitchDirectionView: View {
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var tonicConductor: ViewConductor
    
    var body: some View {
        HStack(spacing: 30) {
            HStack(spacing: 5) {
                let newDownwardTonicMIDI = tonicConductor.tonicMIDI - 12
                Button(action: {
                    tonicConductor.tonicMIDI = newDownwardTonicMIDI
                    viewConductor.tonicMIDI = tonicConductor.tonicMIDI
                    buzz()
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
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 5)
                .foregroundColor(.white)
                .font(Font.system(size: 17, weight: tonicConductor.octaveShift == 0 ? .thin : .regular, design: .monospaced))
            }
            HStack(spacing: 5) {
                PitchDirectionPickerView(viewConductor: viewConductor, tonicConductor: tonicConductor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


