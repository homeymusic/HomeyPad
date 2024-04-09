//
//  HeaderView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/27/24.
//

import SwiftUI

struct HeaderView: View {
    @StateObject var viewConductor: ViewConductor
    
    var body: some View {
        HStack {
            HStack {
                HStack(spacing: 10) {
                    let newDownwardOctaveShift = viewConductor.octaveShift - 1
                    Button(action: {
                        viewConductor.octaveShift = newDownwardOctaveShift
                    }, label: {
                        Image(systemName: "water.waves.and.arrow.down")
                            .foregroundColor(viewConductor.octaveShiftRange.contains(newDownwardOctaveShift) ? .white : Color(UIColor.systemGray4))
                    })
                    .disabled(!viewConductor.octaveShiftRange.contains(newDownwardOctaveShift))
                    
                    Text(viewConductor.octaveShift.formatted(.number.sign(strategy: .always(includingZero: false))))
                        .foregroundColor(.white)
                        .font(Font.system(.body, design: .monospaced))
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(width: 53, alignment: .center)
                    
                    let newUpwardOctaveShift = viewConductor.octaveShift + 1
                    Button(action: {
                        viewConductor.octaveShift = newUpwardOctaveShift
                    }, label: {
                        Image(systemName: "water.waves.and.arrow.up")
                            .foregroundColor(viewConductor.octaveShiftRange.contains(newUpwardOctaveShift) ? .white : Color(UIColor.systemGray4))
                    })
                    .disabled(!viewConductor.octaveShiftRange.contains(newUpwardOctaveShift))
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 4)
                .padding(.horizontal, 4 * 2)
                .foregroundColor(.white)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color(UIColor.systemGray6))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Image(systemName: "tag")
                    .foregroundColor(.white)
                    .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                Image(systemName: "house")
                    .padding(30.0)
                Image(systemName: "paintpalette")
                    .foregroundColor(.white)
                    .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
            }
            HStack {
                Image(systemName: "questionmark.circle")
                    .foregroundColor(.white)
                    .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
