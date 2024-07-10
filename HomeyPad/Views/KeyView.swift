import SwiftUI

struct KeyView: View {
    var keyboardKey: KeyboardKey
    var proxySize: CGSize
    
    var overlayKey: Bool {
        (keyboardKey.conductor.layoutChoice == .symmetric && keyboardKey.interval.intervalClass == .six) || keyboardKey.isSmall
    }
    
    var body: some View {
        let borderWidthApparentSize = overlayKey ? 2.0 * keyboardKey.backgroundBorderSize : keyboardKey.backgroundBorderSize
        let borderHeightApparentSize = keyboardKey.conductor.layoutChoice == .piano ? borderWidthApparentSize / 2 : borderWidthApparentSize
        let outlineWidth = borderWidthApparentSize * keyboardKey.outlineSize
        let outlineHeight = borderHeightApparentSize * keyboardKey.outlineSize
        let alignment: Alignment = keyboardKey.conductor.layoutChoice == .piano ? .top : .center
        
        ZStack(alignment: alignment) {
            KeyRectangle(fillColor: keyboardKey.conductor.backgroundColor, keyboardKey: keyboardKey, proxySize: proxySize)
                .overlay(alignment: alignment) {
                    if keyboardKey.outline {
                        KeyRectangle(fillColor: keyboardKey.outlineColor, keyboardKey: keyboardKey, proxySize: proxySize)
                            .frame(width: proxySize.width - borderWidthApparentSize, height: proxySize.height - borderHeightApparentSize)
                            .overlay(alignment: alignment) {
                                KeyRectangle(fillColor: keyboardKey.outlineKeyColor, keyboardKey: keyboardKey, proxySize: proxySize)
                                    .frame(width: proxySize.width - (keyboardKey.outline ? outlineWidth : borderWidthApparentSize), height: proxySize.height - (keyboardKey.outline ? outlineHeight : borderHeightApparentSize))
                                    .overlay(LabelView(keyboardKey: keyboardKey, proxySize: proxySize)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity))
                            }
                    } else {
                        KeyRectangle(fillColor: keyboardKey.keyColor, keyboardKey: keyboardKey, proxySize: proxySize)
                            .frame(width: proxySize.width - (keyboardKey.outline ? outlineWidth : borderWidthApparentSize), height: proxySize.height - (keyboardKey.outline ? outlineHeight : borderHeightApparentSize))
                            .overlay(LabelView(keyboardKey: keyboardKey, proxySize: proxySize)
                                .frame(maxWidth: .infinity, maxHeight: .infinity))
                            .padding(.leading,  keyboardKey.leadingOffset)
                            .padding(.trailing,  keyboardKey.trailingOffset)
                    }
                }
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
            .padding(.trailing, keyboardKey.trailingPadding(proxySize))
            .cornerRadius(keyboardKey.relativeCornerRadius(in: proxySize))
            .padding(.top, keyboardKey.negativeTopPadding(proxySize))
            .rotationEffect(.degrees(keyboardKey.rotation))
    }
}
