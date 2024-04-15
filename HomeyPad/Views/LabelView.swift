import SwiftUI

public struct LabelView: View {
    var keyboardKey: KeyboardKey
    var proxySize: CGSize
    
    public var body: some View {
        let topBottomPadding = keyboardKey.conductor.layoutChoice == .symmetric && keyboardKey.interval.intervalClass != .six ? proxySize.width / 2.0 : 0.0
        if keyboardKey.conductor.layoutChoice == .symmetric && keyboardKey.interval.consonanceDissonance > .consonant {
            VStack(spacing: 0.0) {
                Labels(keyboardKey: keyboardKey, proxySize: proxySize)
                    .padding([.top, .bottom], topBottomPadding)
                Labels(keyboardKey: keyboardKey, proxySize: proxySize)
                    .padding([.top, .bottom], topBottomPadding)
            }
        } else {
            Labels(keyboardKey: keyboardKey, proxySize: proxySize)
                .padding([.top, .bottom], topBottomPadding)
        }
    }
    
    struct Labels: View {
        var keyboardKey: KeyboardKey
        var proxySize: CGSize
        
        var body: some View {
            VStack(spacing: 0) {
                if keyboardKey.conductor.layoutChoice == .piano {
                    VStack(spacing: 0) {
                        Color.clear
                    }
                    .frame(height: 0.6 * proxySize.height)
                }
                VStack(spacing: 0) {
                    if keyboardKey.conductor.noteLabel[.letter]! {
                        Color.clear.overlay(
                            Text("\(keyboardKey.pitch.letter(keyboardKey.conductor.accidentalChoice()))\(octave)")
                        )
                    }
                    if keyboardKey.conductor.noteLabel[.fixedDo]! {
                        Color.clear.overlay(
                            Text("\(keyboardKey.pitch.fixedDo(keyboardKey.conductor.accidentalChoice()))\(octave)")
                        )
                    }
                    if keyboardKey.conductor.noteLabel[.midi]! {
                        Color.clear.overlay(
                            Text(String(keyboardKey.pitch.midi))
                        )
                    }
                    if keyboardKey.conductor.noteLabel[.frequency]! {
                        Color.clear.overlay(
                            Text(pow(2, CGFloat(keyboardKey.pitch.midi - 69) / 12.0) * 440.0,
                                 format: .number.notation(.compactName).precision(.fractionLength(1)))
                        )
                    }
                    if keyboardKey.conductor.noteLabel[.mode]! {
                        Color.clear.overlay(
                            Text(keyboardKey.pitch.mode.shortHand)
                                .foregroundColor(keyboardKey.accentColor)
                        )
                    }
                    if keyboardKey.conductor.noteLabel[.plot]! {
                        HStack(spacing: 0.0) {
                            Color.clear.overlay(
                                HStack(spacing: 1.0) {
                                    Image(systemName: "square")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.clear)
                                        .overlay(
                                            Image(systemName: keyboardKey.pitch.mode.pitchDirection.icon)
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(Color(keyboardKey.pitch.mode.pitchDirection.majorMinor.color))
                                        )
                                    Image(systemName: "square")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.clear)
                                        .overlay(
                                            Image(systemName: keyboardKey.pitch.mode.chordShape.icon)
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(Color(keyboardKey.pitch.mode.chordShape.majorMinor.color))
                                        )
                                }
                                    .aspectRatio(2.0, contentMode: .fit)
                                    .padding(1.0)
                                    .background(Color(keyboardKey.conductor.brownColor))
                                    .cornerRadius(3.0)
                            )
                        }
                    }
                    if keyboardKey.conductor.noteLabel[.month]! {
                        Color.clear.overlay(
                            Text("\(Calendar.current.shortMonthSymbols[(keyboardKey.pitch.pitchClass.intValue) % 12].capitalized)\(octave)")
                        )
                    }
                    if keyboardKey.conductor.showSymbols {
                        let symbolAdjustedLength = symbolLength(proxySize)
                        VStack(spacing: 0) {
                            ZStack {
                                Color.clear
                                    .frame(width: maxSymbolLength(proxySize))
                                    .overlay(
                                        AnyShape(keySymbol)
                                            .stroke(textColor, lineWidth: keyboardKey.conductor.paletteChoice == .ebonyIvory ? symbolAdjustedLength * 0.1 : 0.0)
                                            .fill(symbolColor)
                                            .aspectRatio(1.0, contentMode: .fit)
                                            .frame(width: symbolAdjustedLength)
                                    )
                            }
                        }
                    }
                    if keyboardKey.conductor.intervalLabel[.interval]! {
                        Color.clear.overlay(
                            Text(String(keyboardKey.interval.shorthand))
                        )
                    }
                    if keyboardKey.conductor.intervalLabel[.movableDo]! {
                        Color.clear.overlay(
                            Text(keyboardKey.interval.movableDo)
                        )
                    }
                    if keyboardKey.conductor.intervalLabel[.roman]! {
                        Color.clear.overlay(
                            Text(String(keyboardKey.interval.roman(globalPitchDirection: keyboardKey.conductor.pitchDirection)))
                        )
                    }
                    if keyboardKey.conductor.intervalLabel[.degree]! {
                        Color.clear.overlay(
                            Text(String(keyboardKey.interval.degree(globalPitchDirection: keyboardKey.conductor.pitchDirection)))
                        )
                    }
                    if keyboardKey.conductor.intervalLabel[.integer]! {
                        Color.clear.overlay(
                            Text(String(keyboardKey.interval.semitones))
                        )
                    }
                }
            }
            .padding(2.0)
            .foregroundColor(textColor)
            .minimumScaleFactor(0.1)
            .lineLimit(1)
        }
        
        func symbolLength(_ size: CGSize) -> CGFloat {
            return minDimension(size) * keyboardKey.interval.consonanceDissonance.symbolLength
        }
        
        func maxSymbolLength(_ size: CGSize) -> CGFloat {
            return minDimension(size) * keyboardKey.interval.consonanceDissonance.maxSymbolLength
        }
        
        func minDimension(_ size: CGSize) -> CGFloat {
            return min(size.width, size.height)
        }
        
        var textColor: Color {
            switch keyboardKey.conductor.paletteChoice {
            case .ebonyIvory:
                return keyboardKey.pitch.accidental ? .white : .black
            case .loud:
                if keyboardKey.tonicTonic {
                    return Color(keyboardKey.conductor.creamColor)
                } else {
                    return symbolColor
                }
            default:
                if keyboardKey.tonicTonic {
                    return keyboardKey.conductor.mainColor
                } else {
                    return symbolColor
                }
            }
        }
        
        var symbolColor: Color {
            let activeColor: Color
            let inactiveColor: Color
            
            switch keyboardKey.conductor.paletteChoice {
            case .subtle:
                if keyboardKey.tonicTonic {
                    activeColor = Color(keyboardKey.interval.majorMinor.color)
                    inactiveColor = Color(keyboardKey.conductor.mainColor)
                } else {
                    activeColor = Color(keyboardKey.conductor.mainColor)
                    inactiveColor = Color(keyboardKey.interval.majorMinor.color)
                }
            case .loud:
                if keyboardKey.tonicTonic {
                    activeColor = Color(keyboardKey.interval.majorMinor.color)
                    inactiveColor = Color(keyboardKey.conductor.creamColor)
                } else {
                    activeColor = Color(keyboardKey.interval.majorMinor.color)
                    inactiveColor = Color(keyboardKey.conductor.mainColor)
                }
            case .ebonyIvory:
                if keyboardKey.tonicTonic {
                    activeColor = Color(keyboardKey.interval.majorMinor.color)
                    inactiveColor = Color(keyboardKey.conductor.creamColor)
                } else {
                    inactiveColor = Color(keyboardKey.pitch.accidental ? keyboardKey.interval.majorMinor.color : keyboardKey.interval.majorMinor.colorOnWhite)
                    activeColor = inactiveColor
                }
            }
            return keyboardKey.activated ? activeColor : inactiveColor
        }
        
        var keySymbol: any Shape {
            return keyboardKey.interval.consonanceDissonance.symbol
        }
        
        
        var octave: String {
            keyboardKey.conductor.noteLabel[.octave]! ? String(keyboardKey.pitch.octave) : ""
        }
    }
}
