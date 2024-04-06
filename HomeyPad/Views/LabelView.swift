import SwiftUI

public struct LabelView: View {
    var keyboardKey: KeyboardKey
    var proxySize: CGSize
    
    public var body: some View {
        //        let padding = proxySize.width / 2.0 + 8.0
        //        let adjustment = keyboardKey.outlineTonic ? keyboardKey.outlineBorderSize : 0.0
        //        let _foo = print("outlineTonic \(keyboardKey.outlineTonic) intervalClass \(keyboardKey.interval.intervalClass)")
        //        let _bar = print("adjustment \(adjustment)")
        if keyboardKey.layoutChoice == .symmetric {
            if keyboardKey.interval.consonanceDissonance > .consonant {
                VStack(spacing: 0.0) {
                    AllSymbolsView(keyboardKey: keyboardKey, proxySize: proxySize)
                    //                        .padding(.top, padding - adjustment)
                    //                        .padding(.bottom, padding)
                    AllSymbolsView(keyboardKey: keyboardKey, proxySize: proxySize)
                    //                        .padding(.top, padding)
                    //                        .padding(.bottom, padding + adjustment)
                }
            } else if keyboardKey.interval.intervalClass == .six {
                AllSymbolsView(keyboardKey: keyboardKey, proxySize: proxySize)
            } else {
                AllSymbolsView(keyboardKey: keyboardKey, proxySize: proxySize)
                //                    .padding(.top, padding - adjustment)
                //                    .padding(.bottom, padding + adjustment)
            }
        } else {
            AllSymbolsView(keyboardKey: keyboardKey, proxySize: proxySize)
            //                .padding(.top, padding - adjustment)
            //                .padding(.bottom, padding - adjustment)
        }
    }
}

struct AllSymbolsView: View {
    
    var keyboardKey: KeyboardKey
    var proxySize: CGSize
    
    var body: some View {
        let anyIntervalLabels: Bool = keyboardKey.whichIntervalLabels.values.contains(true)
        let anyNoteLabels: Bool = keyboardKey.whichNoteLabels.values.contains(true)
        
        VStack(spacing: 0) {
            if keyboardKey.layoutChoice == .piano {
                Color.clear
                Color.clear
                Color.clear
            }
            
            if anyNoteLabels || keyboardKey.showSymbols {
                VStack(spacing: 1.0) {
                    if keyboardKey.noteLabels[keyboardKey.layoutChoice]![.letter]! {
                        Color.clear.overlay(
                            Text(keyboardKey.pitch.letter)
                        )
                    }
                    if keyboardKey.noteLabels[keyboardKey.layoutChoice]![.fixedDo]! {
                        Color.clear.overlay(
                            Text(keyboardKey.pitch.fixedDo)
                        )
                    }
                    if keyboardKey.noteLabels[keyboardKey.layoutChoice]![.month]! {
                        Color.clear.overlay(
                            Text(Calendar.current.shortMonthSymbols[(keyboardKey.pitch.pitchClass.intValue + 3) % 12].uppercased())
                        )
                    }
                    if keyboardKey.noteLabels[keyboardKey.layoutChoice]![.midi]! {
                        Color.clear.overlay(
                            Text(String(keyboardKey.pitch.midi))
                        )
                    }
                    if keyboardKey.noteLabels[keyboardKey.layoutChoice]![.frequency]! {
                        Color.clear.overlay(
                            Text(pow(2, CGFloat(keyboardKey.pitch.midi - 69) / 12.0) * 440.0,
                                 format: .number.notation(.compactName).precision(.fractionLength(1)))
                        )
                    }
                }.frame(maxHeight: .infinity)
            }
            
            if keyboardKey.showSymbols {
                let symbolAdjustedLength = keyboardKey.symbolLength(proxySize)
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        SymbolView(keyboardKey: keyboardKey, proxySize: proxySize, width: symbolAdjustedLength)
                    }
                }
                .frame(height: keyboardKey.maxSymbolLength(proxySize))
            }
            
            if anyIntervalLabels  || keyboardKey.showSymbols {
                VStack(spacing: 1.0) {
                    if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.interval]! {
                        Color.clear.overlay(
                            Text(String(keyboardKey.interval.interval))
                        )
                    }
                    if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.movableDo]! {
                        Color.clear.overlay(
                            Text(keyboardKey.interval.movableDo)
                        )
                    }
                    if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.roman]! {
                        Color.clear.overlay(
                            Text(String(keyboardKey.interval.roman))
                        )
                    }
                    if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.degree]! {
                        Color.clear.overlay(
                            Text(String(keyboardKey.interval.degree))
                        )
                    }
                    if keyboardKey.intervalLabels[keyboardKey.layoutChoice]![.integer]! {
                        Color.clear.overlay(
                            Text(String(keyboardKey.interval.semitones))
                        )
                    }
                }
                .frame(maxHeight: .infinity)
            }
            
        }
        .font(.custom("Courier", size: 28))
        .foregroundColor(keyboardKey.textColor)
        .lineLimit(1)
        .minimumScaleFactor(0.01)
        .padding(3.0)
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
