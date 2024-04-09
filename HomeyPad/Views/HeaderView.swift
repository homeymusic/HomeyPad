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
                HStack(spacing: 5) {
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
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(width: 41, alignment: .center)
                    
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
                .padding(.vertical, 5)
                .foregroundColor(.white)
                .font(Font.system(size: 17, weight: viewConductor.octaveShift == 0 ? .thin : .regular, design: .monospaced))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Image(systemName: "tag")
                    .foregroundColor(.white)
                    .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                
                Button(action: {
                    withAnimation {
                        viewConductor.showTonicPicker.toggle()
                    }
                }) {
                    ZStack {
                        Color.clear.overlay(
                            Image(systemName: viewConductor.showTonicPicker ? "house.fill" : "house")
                                .foregroundColor(.white)
                                .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                    }
                    .padding(30.0)
                }
                
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
