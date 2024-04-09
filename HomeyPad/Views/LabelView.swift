import SwiftUI

public struct LabelView: View {
    var keyboardKey: KeyboardKey
    var proxySize: CGSize
    
    public var body: some View {
        let topBottomPadding = keyboardKey.viewConductor.layoutChoice == .symmetric && keyboardKey.interval.intervalClass != .six ? proxySize.width / 2.0 : 0.0
        if keyboardKey.viewConductor.layoutChoice == .symmetric && keyboardKey.interval.consonanceDissonance > .consonant {
            VStack(spacing: 0.0) {
                AllSymbolsView(keyboardKey: keyboardKey, proxySize: proxySize)
                    .padding([.top, .bottom], topBottomPadding)
                AllSymbolsView(keyboardKey: keyboardKey, proxySize: proxySize)
                    .padding([.top, .bottom], topBottomPadding)
            }
        } else {
            AllSymbolsView(keyboardKey: keyboardKey, proxySize: proxySize)
                .padding([.top, .bottom], topBottomPadding)
        }
    }
    
    struct AllSymbolsView: View {
        
        var keyboardKey: KeyboardKey
        var proxySize: CGSize
    
        var body: some View {
            let labelPadding: CGFloat = 2.0
            let anyIntervalLabels: Bool = keyboardKey.whichIntervalLabels.values.contains(true)
            let anyNoteLabels: Bool = keyboardKey.whichNoteLabels.values.contains(true)
            
            VStack(spacing: 0) {
                if keyboardKey.viewConductor.layoutChoice == .piano {
                    Color.clear
                    Color.clear
                    Color.clear
                }
                
                if anyIntervalLabels  || keyboardKey.viewConductor.showSymbols {
                    VStack(spacing: 1.0) {
                        if keyboardKey.viewConductor.intervalLabels[keyboardKey.viewConductor.layoutChoice]![.interval]! {
                            Color.clear.overlay(
                                Text(String(keyboardKey.interval.interval))
                            )
                        }
                        if keyboardKey.viewConductor.intervalLabels[keyboardKey.viewConductor.layoutChoice]![.movableDo]! {
                            Color.clear.overlay(
                                Text(keyboardKey.interval.movableDo)
                            )
                        }
                        if keyboardKey.viewConductor.intervalLabels[keyboardKey.viewConductor.layoutChoice]![.roman]! {
                            Color.clear.overlay(
                                Text(String(keyboardKey.interval.roman))
                            )
                        }
                        if keyboardKey.viewConductor.intervalLabels[keyboardKey.viewConductor.layoutChoice]![.degree]! {
                            Color.clear.overlay(
                                Text(String(keyboardKey.interval.degree))
                            )
                        }
                        if keyboardKey.viewConductor.intervalLabels[keyboardKey.viewConductor.layoutChoice]![.integer]! {
                            Color.clear.overlay(
                                Text(String(keyboardKey.interval.semitones))
                            )
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding(labelPadding)
                }                

                if keyboardKey.viewConductor.showSymbols {
                    let symbolAdjustedLength = keyboardKey.symbolLength(proxySize)
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            SymbolView(keyboardKey: keyboardKey, proxySize: proxySize, width: symbolAdjustedLength)
                        }
                    }
                    .frame(height: keyboardKey.maxSymbolLength(proxySize))
                }
                
                if anyNoteLabels || keyboardKey.viewConductor.showSymbols {
                    VStack(spacing: 1.0) {
                        if keyboardKey.viewConductor.noteLabels[keyboardKey.viewConductor.layoutChoice]![.letter]! {
                            Color.clear.overlay(
                                Text("\(keyboardKey.pitch.letter)\(octave)")
                            )
                        }
                        if keyboardKey.viewConductor.noteLabels[keyboardKey.viewConductor.layoutChoice]![.fixedDo]! {
                            Color.clear.overlay(
                                Text("\(keyboardKey.pitch.fixedDo)\(octave)")
                            )
                        }
                        if keyboardKey.viewConductor.noteLabels[keyboardKey.viewConductor.layoutChoice]![.month]! {
                            Color.clear.overlay(
                                Text("\(Calendar.current.shortMonthSymbols[(keyboardKey.pitch.pitchClass.intValue + 3) % 12].capitalized)\(octave)")
                            )
                        }
                        if keyboardKey.viewConductor.noteLabels[keyboardKey.viewConductor.layoutChoice]![.midi]! {
                            Color.clear.overlay(
                                Text(String(keyboardKey.pitch.midi))
                            )
                        }
                        if keyboardKey.viewConductor.noteLabels[keyboardKey.viewConductor.layoutChoice]![.frequency]! {
                            Color.clear.overlay(
                                Text(pow(2, CGFloat(keyboardKey.pitch.midi - 69) / 12.0) * 440.0,
                                     format: .number.notation(.compactName).precision(.fractionLength(1)))
                            )
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding(labelPadding)
                }
                
            }
            .font(.custom("Courier", size: 28))
            .foregroundColor(keyboardKey.textColor)
            .lineLimit(1)
            .minimumScaleFactor(0.01)
        }
        
        var octave: String {
            keyboardKey.viewConductor.noteLabels[keyboardKey.viewConductor.layoutChoice]![.octave]! ? String(keyboardKey.pitch.octave) : ""
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
                            .stroke(keyboardKey.textColor, lineWidth: keyboardKey.viewConductor.paletteChoice == .ebonyIvory ? width * 0.1 : 0.0)
                            .fill(keyboardKey.symbolColor)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: width)
                    )
            }
        }
    }
}
