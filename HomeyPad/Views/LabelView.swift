import SwiftUI

public struct LabelView: View {
    var keyboardKey: KeyboardKey
    var proxySize: CGSize
    
    public var body: some View {
        let padding = proxySize.width / 2.0 + 8.0
        let paddingAdjustment = keyboardKey.outlineTonic ? 1.5 : 0.0
        if keyboardKey.layoutChoice == .symmetric {
            if keyboardKey.interval.consonanceDissonance > .consonant {
                VStack(spacing: 0.0) {
                    AllSymbolsView(keyboardKey: keyboardKey, proxySize: proxySize)
                        .padding(.top, padding - paddingAdjustment)
                        .padding(.bottom, padding + 1.5)
                    AllSymbolsView(keyboardKey: keyboardKey, proxySize: proxySize)
                        .padding(.top, padding + 1.5)
                        .padding(.bottom, padding - paddingAdjustment)
                }
            } else if keyboardKey.interval.intervalClass == .six {
                AllSymbolsView(keyboardKey: keyboardKey, proxySize: proxySize)
            } else {
                AllSymbolsView(keyboardKey: keyboardKey, proxySize: proxySize)
                    .padding(.top, padding)
                    .padding(.bottom, padding)
            }
        } else {
            AllSymbolsView(keyboardKey: keyboardKey, proxySize: proxySize)
        }
    }
}

struct AllSymbolsView: View {
    
    var keyboardKey: KeyboardKey
    var proxySize: CGSize
    
    var body: some View {
        VStack(spacing: 0) {
            if keyboardKey.layoutChoice == .piano {
                Color.clear
                Color.clear
                Color.clear
            }
            Color.clear.overlay(
                VStack(spacing: 1.0) {
                    if keyboardKey.noteLabels[keyboardKey.layoutChoice]![.letter]! {
                        Text(keyboardKey.pitch.letter)
                    }
                    if keyboardKey.noteLabels[keyboardKey.layoutChoice]![.fixedDo]! {
                        Text(keyboardKey.pitch.fixedDo)
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
            )
            .padding(.bottom, 2.5)
            VStack(spacing: 0) {
                let symbolAdjustedLength = keyboardKey.symbolLength(proxySize)
                if keyboardKey.showSymbols {
                    VStack(spacing: 0) {
                        SymbolView(keyboardKey: keyboardKey, proxySize: proxySize, width: symbolAdjustedLength)
                    }
                } else {
                    Color.clear
                        .frame(height: keyboardKey.maxSymbolLength(proxySize))
                }
            }
            Color.clear.overlay(
                VStack(spacing: 1.0) {
                    if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.interval]! {
                        Text(String(keyboardKey.interval.interval))
                    }
                    if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.movableDo]! {
                        Text(keyboardKey.interval.movableDo)
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
                }
            )
            .padding(.top, 5.0)
        }
        .scaledToFit()
        .lineLimit(1)
        .minimumScaleFactor(0.01)
        .font(.custom("Courier", size: 28))
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
                .overlay(
                    AnyShape(keyboardKey.keySymbol)
                        .aspectRatio(1.0, contentMode: .fit)
                        .foregroundColor(keyboardKey.symbolColor)
                        .frame(width: width)
                )
        }
    }
}
