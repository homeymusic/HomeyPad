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
                Image(systemName: "water.waves.and.arrow.down")
                    .foregroundColor(.white)
                    .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                Text("0")
                    .font(.custom("Courier", size: 20.0))
                Image(systemName: "water.waves.and.arrow.up")
                    .foregroundColor(.white)
                    .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, viewConductor.headerFooterPadding)
            HStack {
                Image(systemName: "tag")
                    .foregroundColor(.white)
                    .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                Image(systemName: "house.fill")
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
            .padding(.trailing, viewConductor.headerFooterPadding)
        }
    }
}
