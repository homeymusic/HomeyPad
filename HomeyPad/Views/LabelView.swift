import SwiftUI

public struct LabelView: View {
    var keyboardKey: KeyboardKey
    var proxySize: CGSize
    
    public var body: some View {
        VStack {
            if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.interval]! {
                Text(String(keyboardKey.interval.interval))
            }
            if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.roman]! {
                Text(String(keyboardKey.interval.roman))
            }
            if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.degree]! {
                Text(String(keyboardKey.interval.degree))
            }
            if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.integer]! {
                Text(String(keyboardKey.interval.semitones))
            }
            if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.symbol]! {
                let symbolAdjustedLength = keyboardKey.symbolLength(proxySize)
                if keyboardKey.layoutChoice == .symmetric && keyboardKey.interval.consonanceDissonance > .consonant {
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
                    let offset = keyboardKey.layoutChoice == .piano ? -proxySize.height * (keyboardKey.isSmall ? 0.3 : 0.2) : 0
                    ZStack {
                        SymbolView(keyboardKey: keyboardKey, proxySize: proxySize, width: symbolAdjustedLength)
                            .offset(y: offset)
                    }
                }
            }
            if keyboardKey.noteLabels[keyboardKey.layoutChoice]![.letter]! {
                Text(keyboardKey.pitch.letter)
            }
            if keyboardKey.noteLabels[keyboardKey.layoutChoice]![.month]! {
                Text(Calendar.current.shortMonthSymbols[(keyboardKey.pitch.pitchClass.intValue + 3) % 12].uppercased())
            }
            if keyboardKey.noteLabels[keyboardKey.layoutChoice]![.midi]! {
                Text(String(keyboardKey.pitch.midi))
            }
            if keyboardKey.noteLabels[keyboardKey.layoutChoice]![.frequency]! {
                Text(pow(2, CGFloat(keyboardKey.pitch.midi - 69) / 12.0) * 440.0,
                     format: .number.notation(.compactName).precision(.fractionLength(1)))
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
