import SwiftUI

struct KeyView: View {
    var keyboardKey: KeyboardKey
    var proxySize: CGSize

    var overlayKey: Bool {
        (keyboardKey.conductor.layoutChoice == .symmetric && keyboardKey.pitch.pitchClass == .six) || keyboardKey.isSmall
    }
    
    var body: some View {
        ZStack(alignment: keyboardKey.conductor.layoutChoice == .piano ? .top : .center) {
            let borderWidthApparentSize = overlayKey ? 2.0 * keyboardKey.backgroundBorderSize : keyboardKey.backgroundBorderSize
            let borderHeightApparentSize = keyboardKey.conductor.layoutChoice == .piano ? borderWidthApparentSize / 2 : borderWidthApparentSize
            let tonicTonic = keyboardKey.conductor.layoutChoice == .tonic && keyboardKey.pitch == keyboardKey.conductor.tonicPitch
            let outlineWidth = borderWidthApparentSize * (tonicTonic ? 2.5 : 2.0)
            let outlineHeight = borderHeightApparentSize * (tonicTonic ? 2.5 : 2.0)
            KeyRectangle(fillColor: keyboardKey.conductor.backgroundColor, keyboardKey: keyboardKey, proxySize: proxySize)
            if keyboardKey.outlineTonic {
                KeyRectangle(fillColor: tonicTonic ? keyboardKey.conductor.mainColor : keyboardKey.conductor.accentColor, keyboardKey: keyboardKey, proxySize: proxySize)
                    .frame(width: proxySize.width - borderWidthApparentSize, height: proxySize.height - borderHeightApparentSize)
            }
            KeyRectangle(fillColor: keyboardKey.keyColor, keyboardKey: keyboardKey, proxySize: proxySize)
                .frame(width: proxySize.width - (keyboardKey.outlineTonic ? outlineWidth : borderWidthApparentSize), height: proxySize.height - (keyboardKey.outlineTonic ? outlineHeight : borderHeightApparentSize))
                .overlay(LabelView(keyboardKey: keyboardKey,
                                   proxySize: proxySize)
                    .frame(maxWidth: .infinity, maxHeight: .infinity))
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
