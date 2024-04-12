import SwiftUI

public struct LabelView: View {
    var keyboardKey: KeyboardKey
    var proxySize: CGSize
    
    public var body: some View {
        let topBottomPadding = keyboardKey.conductor.layoutChoice == .symmetric && keyboardKey.interval.intervalClass != .six ? proxySize.width / 2.0 : 0.0
        if keyboardKey.conductor.layoutChoice == .symmetric && keyboardKey.interval.consonanceDissonance > .consonant {
            VStack(spacing: 0.0) {
                AllSymbolsView(keyboardKey: keyboardKey,
                               proxySize: proxySize)
                    .padding([.top, .bottom], topBottomPadding)
                AllSymbolsView(keyboardKey: keyboardKey,
                               proxySize: proxySize)
                    .padding([.top, .bottom], topBottomPadding)
            }
        } else {
            AllSymbolsView(keyboardKey: keyboardKey,
                           proxySize: proxySize)
                .padding([.top, .bottom], topBottomPadding)
        }
    }
    
    struct AllSymbolsView: View {
        var keyboardKey: KeyboardKey
        var proxySize: CGSize

        var whichIntervalLabels: [IntervalLabelChoice: Bool] {
            keyboardKey.conductor.intervalLabels[keyboardKey.conductor.layoutChoice]!
        }
        
        var whichNoteLabels: [NoteLabelChoice: Bool] {
            keyboardKey.conductor.noteLabels[keyboardKey.conductor.layoutChoice]!
        }
        
        func symbolLength(_ size: CGSize) -> CGFloat {
            return minDimension(size) * keyboardKey.interval.consonanceDissonance.symbolLength/* * (isSmall ? 1.25 : 1.0)*/
        }
        
        func maxSymbolLength(_ size: CGSize) -> CGFloat {
            return minDimension(size) * keyboardKey.interval.consonanceDissonance.maxSymbolLength/* * (isSmall ? 1.25 : 1.0)*/
        }
        
        func minDimension(_ size: CGSize) -> CGFloat {
            return min(size.width, size.height)
        }
        
        var tonicTonic: Bool {
            keyboardKey.conductor.layoutChoice == .tonic && keyboardKey.pitch == keyboardKey.conductor.tonicPitch
        }
        
        var textColor: Color {
            switch keyboardKey.conductor.paletteChoice {
            case .ebonyIvory:
                if  tonicTonic {
                    return Color(keyboardKey.conductor.creamColor)
                } else {
                    return keyboardKey.pitch.accidental ? Color(keyboardKey.conductor.creamColor) : Color(keyboardKey.conductor.brownColor)
                }
            case .loud:
                if  tonicTonic {
                    return Color(keyboardKey.conductor.creamColor)
                } else {
                    return symbolColor
                }
            default:
                if tonicTonic {
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
                if tonicTonic {
                    activeColor = Color(keyboardKey.interval.majorMinor.color)
                    inactiveColor = Color(keyboardKey.conductor.mainColor)
                } else {
                    activeColor = Color(keyboardKey.conductor.mainColor)
                    inactiveColor = Color(keyboardKey.interval.majorMinor.color)
                }
            case .loud:
                if tonicTonic {
                    activeColor = Color(keyboardKey.interval.majorMinor.color)
                    inactiveColor = Color(keyboardKey.conductor.creamColor)
                } else {
                    activeColor = Color(keyboardKey.interval.majorMinor.color)
                    inactiveColor = Color(keyboardKey.conductor.mainColor)
                }
            case .ebonyIvory:
                if tonicTonic {
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

        var body: some View {
            let labelPadding: CGFloat = 2.0
            let anyIntervalLabels: Bool = whichIntervalLabels.filter({ $0.key != IntervalLabelChoice.symbol}).values.contains(true)
            let anyNoteLabels: Bool = whichNoteLabels.filter({ $0.key != .octave}).values.contains(true)
            
            VStack(spacing: 0) {
                if keyboardKey.conductor.layoutChoice == .piano {
                    Color.clear
                    Color.clear
                    Color.clear
                }
                if anyNoteLabels || keyboardKey.conductor.showSymbols {
                    VStack(spacing: 1.0) {
                        if keyboardKey.conductor.noteLabels[keyboardKey.conductor.layoutChoice]![.letter]! {
                            Color.clear.overlay(
                                Text("\(keyboardKey.pitch.letter(keyboardKey.conductor.accidentalChoice()))\(octave)")
                            )
                        }
                        if keyboardKey.conductor.noteLabels[keyboardKey.conductor.layoutChoice]![.fixedDo]! {
                            Color.clear.overlay(
                                Text("\(keyboardKey.pitch.fixedDo(keyboardKey.conductor.accidentalChoice()))\(octave)")
                            )
                        }
                        if keyboardKey.conductor.noteLabels[keyboardKey.conductor.layoutChoice]![.mode]! {
                            Color.clear.overlay(
                                Text(keyboardKey.pitch.mode)
                            )
                        }
                        if keyboardKey.conductor.noteLabels[keyboardKey.conductor.layoutChoice]![.month]! {
                            Color.clear.overlay(
                                Text("\(Calendar.current.shortMonthSymbols[(keyboardKey.pitch.pitchClass.intValue) % 12].capitalized)\(octave)")
                            )
                        }
                        if keyboardKey.conductor.noteLabels[keyboardKey.conductor.layoutChoice]![.midi]! {
                            Color.clear.overlay(
                                Text(String(keyboardKey.pitch.midi))
                            )
                        }
                        if keyboardKey.conductor.noteLabels[keyboardKey.conductor.layoutChoice]![.frequency]! {
                            Color.clear.overlay(
                                Text(pow(2, CGFloat(keyboardKey.pitch.midi - 69) / 12.0) * 440.0,
                                     format: .number.notation(.compactName).precision(.fractionLength(1)))
                            )
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding(labelPadding)
                }
                
                if keyboardKey.conductor.showSymbols {
                    let symbolAdjustedLength = symbolLength(proxySize)
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            ZStack {
                                Color.clear
                                    .aspectRatio(1.0, contentMode: .fit)
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
                    .frame(height: maxSymbolLength(proxySize))
                }
                
                if anyIntervalLabels  || keyboardKey.conductor.showSymbols {
                    VStack(spacing: 1.0) {
                        if keyboardKey.conductor.intervalLabels[keyboardKey.conductor.layoutChoice]![.interval]! {
                            Color.clear.overlay(
                                Text(String(keyboardKey.interval.interval))
                            )
                        }
                        if keyboardKey.conductor.intervalLabels[keyboardKey.conductor.layoutChoice]![.movableDo]! {
                            Color.clear.overlay(
                                Text(keyboardKey.interval.movableDo)
                            )
                        }
                        if keyboardKey.conductor.intervalLabels[keyboardKey.conductor.layoutChoice]![.roman]! {
                            Color.clear.overlay(
                                Text(String(keyboardKey.interval.roman))
                            )
                        }
                        if keyboardKey.conductor.intervalLabels[keyboardKey.conductor.layoutChoice]![.degree]! {
                            Color.clear.overlay(
                                Text(String(keyboardKey.interval.degree))
                            )
                        }
                        if keyboardKey.conductor.intervalLabels[keyboardKey.conductor.layoutChoice]![.integer]! {
                            Color.clear.overlay(
                                Text(String(keyboardKey.interval.semitones))
                            )
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding(labelPadding)
                }
                
            }
            .font(Font.system(size: 17, design: .monospaced))
            .foregroundColor(textColor)
            .lineLimit(1)
            .minimumScaleFactor(0.01)
        }
        
        var octave: String {
            keyboardKey.conductor.noteLabels[keyboardKey.conductor.layoutChoice]![.octave]! ? String(keyboardKey.pitch.octave) : ""
        }
    }
}
