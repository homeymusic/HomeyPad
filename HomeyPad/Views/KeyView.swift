//
//  SwiftUIView.swift
//
//
//  Created by Brian McAuliff Mulloy on 3/31/24.
//

import SwiftUI

struct KeyView: View {
    var keyboardKey: KeyboardKey
    var proxySize: CGSize

    var body: some View {
        ZStack(alignment: keyboardKey.formFactor == .piano ? .top : .center) {
            let borderSize = keyboardKey.isSmall ? 1.0 : 3.0
            let borderWidthApparentSize = keyboardKey.formFactor == .symmetric && keyboardKey.pitch.pitchClass == .six || keyboardKey.isSmall ? 2.0 * borderSize : borderSize
            let borderHeightApparentSize = keyboardKey.formFactor == .piano && keyboardKey.viewpoint == .intervallic ? borderWidthApparentSize / 2 : borderWidthApparentSize
            let outlineTonic: Bool = keyboardKey.pitch.pitchClass == .zero && keyboardKey.viewpoint == .intervallic
            Rectangle()
                .fill(keyboardKey.backgroundColor)
                .padding(.top, keyboardKey.topPadding(proxySize))
                .padding(.leading, keyboardKey.leadingPadding(proxySize))
                .cornerRadius(keyboardKey.relativeCornerRadius(in: proxySize))
                .padding(.top, keyboardKey.negativeTopPadding(proxySize))
                .padding(.leading, keyboardKey.negativeLeadingPadding(proxySize))
            if outlineTonic {
                Rectangle()
                    .fill(keyboardKey.symbolColor)
                    .padding(.top, keyboardKey.topPadding(proxySize))
                    .padding(.leading, keyboardKey.leadingPadding(proxySize))
                    .cornerRadius(keyboardKey.relativeCornerRadius(in: proxySize))
                    .padding(.top, keyboardKey.negativeTopPadding(proxySize))
                    .padding(.leading, keyboardKey.negativeLeadingPadding(proxySize))
                    .frame(width: proxySize.width - borderWidthApparentSize, height: proxySize.height - borderHeightApparentSize)
            }
            Rectangle()
                .fill(keyboardKey.keyColor)
                .padding(.top, keyboardKey.topPadding(proxySize))
                .padding(.leading, keyboardKey.leadingPadding(proxySize))
                .cornerRadius(keyboardKey.relativeCornerRadius(in: proxySize))
                .padding(.top, keyboardKey.negativeTopPadding(proxySize))
                .padding(.leading, keyboardKey.negativeLeadingPadding(proxySize))
                .frame(width: proxySize.width - (outlineTonic ? 2.0 * borderWidthApparentSize: borderWidthApparentSize), height: proxySize.height - (outlineTonic ? 2.0 * borderHeightApparentSize: borderHeightApparentSize))
        }
    }
}
