import SwiftUI

struct OctaveShiftView: View {
    @StateObject var viewConductor: ViewConductor
    @StateObject var tonicConductor: ViewConductor
    
    let octaveShiftRange: ClosedRange<Int8> = Int8(-5)...Int8(+5)
    @State var octaveShift: Int8 = 0 {
        willSet(newOctaveShift) {
            assert(octaveShiftRange.contains(newOctaveShift))
        }
        didSet {
            viewConductor.octaveShift = octaveShift
            tonicConductor.octaveShift = octaveShift
        }
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 5) {
                let newDownwardOctaveShift = octaveShift - 1
                Button(action: {
                    octaveShift = newDownwardOctaveShift
                }, label: {
                    Image(systemName: "water.waves.and.arrow.down")
                        .foregroundColor(octaveShiftRange.contains(newDownwardOctaveShift) ? .white : Color(UIColor.systemGray4))
                })
                .disabled(!octaveShiftRange.contains(newDownwardOctaveShift))
                
                Text(octaveShift.formatted(.number.sign(strategy: .always(includingZero: false))))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(width: 41, alignment: .center)
                
                let newUpwardOctaveShift = octaveShift + 1
                Button(action: {
                    octaveShift = newUpwardOctaveShift
                }, label: {
                    Image(systemName: "water.waves.and.arrow.up")
                        .foregroundColor(octaveShiftRange.contains(newUpwardOctaveShift) ? .white : Color(UIColor.systemGray4))
                })
                .disabled(!octaveShiftRange.contains(newUpwardOctaveShift))
                
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, 5)
            .foregroundColor(.white)
            .font(Font.system(size: 17, weight: octaveShift == 0 ? .thin : .regular, design: .monospaced))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

