import SwiftUI

public struct LabelView: View {
    var keyboardKey: KeyboardKey
    var proxySize: CGSize
    
    public var body: some View {
        VStack(spacing: 0) {
            if keyboardKey.layoutChoice == .piano {
                Color.clear
                Color.clear
                Color.clear
            }
            Color.clear.overlay(
                VStack(spacing: 1.0) {
                    if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.interval]! {
                        Text(String(keyboardKey.interval.interval))
                            .scaledToFit()
                    }
                    if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.roman]! {
                        Text(String(keyboardKey.interval.roman))
                            .scaledToFit()
                    }
                    if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.degree]! {
                        Text(String(keyboardKey.interval.degree))
                            .scaledToFit()
                    }
                    if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.integer]! {
                        Text(String(keyboardKey.interval.semitones))
                            .scaledToFit()
                    }
                }
                    .padding(5.0)
            )
            VStack(spacing: 0) {
                let symbolAdjustedLength = keyboardKey.symbolLength(proxySize)
                if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.symbol]! {
                    VStack(spacing: 0) {
                        if keyboardKey.layoutChoice == .symmetric && keyboardKey.interval.consonanceDissonance > .consonant {
                            SymbolView(keyboardKey: keyboardKey, proxySize: proxySize, width: symbolAdjustedLength)
                                .frame(height: proxySize.height / 2)
                            SymbolView(keyboardKey: keyboardKey, proxySize: proxySize, width: symbolAdjustedLength)
                                .frame(height: proxySize.height / 2)
                        } else  {
                            ZStack {
                                SymbolView(keyboardKey: keyboardKey, proxySize: proxySize, width: symbolAdjustedLength)
                            }
                        }
                    }
                } else {
                    Color.clear
                        .frame(height: keyboardKey.maxSymbolLength(proxySize))
                }
            }
            Color.clear.overlay(
                VStack(spacing: 1.0) {
                    if keyboardKey.noteLabels[keyboardKey.layoutChoice]![.letter]! {
                        Text(keyboardKey.pitch.letter)
                            .scaledToFit()
                    }
                    if keyboardKey.noteLabels[keyboardKey.layoutChoice]![.month]! {
                        Text(Calendar.current.shortMonthSymbols[(keyboardKey.pitch.pitchClass.intValue + 3) % 12].uppercased())
                            .scaledToFit()
                    }
                    if keyboardKey.noteLabels[keyboardKey.layoutChoice]![.midi]! {
                        Text(String(keyboardKey.pitch.midi))
                            .scaledToFit()
                    }
                    if keyboardKey.noteLabels[keyboardKey.layoutChoice]![.frequency]! {
                        Text(pow(2, CGFloat(keyboardKey.pitch.midi - 69) / 12.0) * 440.0,
                             format: .number.notation(.compactName).precision(.fractionLength(1)))
                        .scaledToFit()
                    }
                }
                    .padding(5.0)
            )
        }
        .lineLimit(1)
        .minimumScaleFactor(0.01)
        .font(.custom("Courier", size: 20))
        .foregroundColor(keyboardKey.textColor)
    }
}


struct SymbolView: View {
    var keyboardKey: KeyboardKey
    var proxySize: CGSize
    var width: CGFloat
    var body: some View {
        ZStack {
            Color.clear
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: keyboardKey.maxSymbolLength(proxySize))
            AnyShape(keyboardKey.keySymbol)
                .aspectRatio(1.0, contentMode: .fit)
                .foregroundColor(keyboardKey.symbolColor)
                .frame(width: width)
        }
    }
}
