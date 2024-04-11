import SwiftUI

struct OctaveShiftView: View {
    @StateObject var viewConductor: ViewConductor
    @StateObject var tonicConductor: ViewConductor

    var body: some View {
        HStack {
            HStack(spacing: 5) {
                let newDownwardOctaveShift = viewConductor.octaveShift - 1
                Button(action: {
                    viewConductor.octaveShift = newDownwardOctaveShift
                    tonicConductor.octaveShift = viewConductor.octaveShift
                }, label: {
                    Image(systemName: "water.waves.and.arrow.down")
                        .foregroundColor(viewConductor.octaveShiftRange.contains(newDownwardOctaveShift) ? .white : Color(UIColor.systemGray4))
                })
                .disabled(!viewConductor.octaveShiftRange.contains(newDownwardOctaveShift))
                
                Text(viewConductor.octaveShift.formatted(.number.sign(strategy: .always(includingZero: false))))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(width: 41, alignment: .center)
                
                let newUpwardOctaveShift = viewConductor.octaveShift + 1
                Button(action: {
                    viewConductor.octaveShift = newUpwardOctaveShift
                    tonicConductor.octaveShift = viewConductor.octaveShift
                }, label: {
                    Image(systemName: "water.waves.and.arrow.up")
                        .foregroundColor(viewConductor.octaveShiftRange.contains(newUpwardOctaveShift) ? .white : Color(UIColor.systemGray4))
                })
                .disabled(!viewConductor.octaveShiftRange.contains(newUpwardOctaveShift))
                
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, 5)
            .foregroundColor(.white)
            .font(Font.system(size: 17, weight: viewConductor.octaveShift == 0 ? .thin : .regular, design: .monospaced))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

