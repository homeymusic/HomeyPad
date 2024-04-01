import SwiftUI

public struct LabelView: View {
    var keyboardKey: KeyboardKey
    var proxySize: CGSize
    
    public var body: some View {
        let symbolAdjustedLength = keyboardKey.symbolLength(proxySize) * (keyboardKey.isSmall ? 1.25 : 1.0)
        if keyboardKey.formFactor == .symmetric && keyboardKey.interval.consonanceDissonance > .consonant {
            VStack(spacing: 0) {
                let offset = proxySize.height * 0.25 + 0.5 * symbolAdjustedLength
                ZStack {
                    SymbolView(keyboardKey: keyboardKey, proxySize: proxySize, width: symbolAdjustedLength)
                }
                .offset(y: offset)
                ZStack {
                    SymbolView(keyboardKey: keyboardKey, proxySize: proxySize, width: symbolAdjustedLength)
                }
                .offset(y: -offset)
            }
        } else  {
            let offset = keyboardKey.formFactor == .piano ? -proxySize.height * (keyboardKey.isSmall ? 0.3 : 0.2) : 0
            ZStack {
                SymbolView(keyboardKey: keyboardKey, proxySize: proxySize, width: symbolAdjustedLength)
                    .offset(y: offset)
            }
        }
    }
}

struct SymbolView: View {
    var keyboardKey: KeyboardKey
    var proxySize: CGSize
    var width: CGFloat
    
    var body: some View {
        AnyShape(keyboardKey.keySymbol)
            .foregroundColor(keyboardKey.symbolColor)
            .aspectRatio(1.0, contentMode: .fit)
            .frame(width: width)
    }
}
