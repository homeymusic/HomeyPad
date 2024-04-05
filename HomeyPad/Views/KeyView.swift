import SwiftUI

struct KeyView: View {
    var keyboardKey: KeyboardKey
    var proxySize: CGSize

    var overlayKey: Bool {
        (keyboardKey.layoutChoice == .symmetric && keyboardKey.pitch.pitchClass == .six) || keyboardKey.isSmall
    }
    
    var body: some View {
        ZStack(alignment: keyboardKey.layoutChoice == .piano ? .top : .center) {
            let borderSize = 3.0
            let borderWidthApparentSize = overlayKey ? 2.0 * borderSize : borderSize
            let borderHeightApparentSize = keyboardKey.layoutChoice == .piano ? borderWidthApparentSize / 2 : borderWidthApparentSize
            let outlineTonic: Bool = keyboardKey.paletteChoice == .subtle && keyboardKey.pitch.pitchClass == .zero
            KeyRectangle(fillColor: keyboardKey.backgroundColor, keyboardKey: keyboardKey, proxySize: proxySize)
            if outlineTonic {
                KeyRectangle(fillColor: Color(keyboardKey.accentColor), keyboardKey: keyboardKey, proxySize: proxySize)
                    .frame(width: proxySize.width - borderWidthApparentSize, height: proxySize.height - borderHeightApparentSize)
            }
            KeyRectangle(fillColor: keyboardKey.keyColor, keyboardKey: keyboardKey, proxySize: proxySize)
                .frame(width: proxySize.width - (outlineTonic ? 2.0 * borderWidthApparentSize: borderWidthApparentSize), height: proxySize.height - (outlineTonic ? 2.0 * borderHeightApparentSize: borderHeightApparentSize))
        }
    }
}

struct KeyRectangle: View {
    var fillColor: Color
    var keyboardKey: KeyboardKey
    var proxySize: CGSize

    var body: some View {
        Rectangle()
            .fill(fillColor)
            .padding(.top, keyboardKey.topPadding(proxySize))
            .padding(.leading, keyboardKey.leadingPadding(proxySize))
            .cornerRadius(keyboardKey.relativeCornerRadius(in: proxySize))
            .padding(.top, keyboardKey.negativeTopPadding(proxySize))
            .padding(.leading, keyboardKey.negativeLeadingPadding(proxySize))
    }
}
