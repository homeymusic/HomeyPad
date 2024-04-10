import SwiftUI

public struct LabelView: View {
    var viewConductor: ViewConductor
    var pitch: Pitch
    var interval: Interval
    var proxySize: CGSize
    
    public var body: some View {
        let topBottomPadding = viewConductor.layoutChoice == .symmetric && interval.intervalClass != .six ? proxySize.width / 2.0 : 0.0
        if viewConductor.layoutChoice == .symmetric && interval.consonanceDissonance > .consonant {
            VStack(spacing: 0.0) {
                AllSymbolsView(viewConductor: viewConductor,
                               pitch: pitch,
                               interval: interval,
                               proxySize: proxySize)
                    .padding([.top, .bottom], topBottomPadding)
                AllSymbolsView(viewConductor: viewConductor,
                               pitch: pitch,
                               interval: interval,
                               proxySize: proxySize)
                    .padding([.top, .bottom], topBottomPadding)
            }
        } else {
            AllSymbolsView(viewConductor: viewConductor,
                           pitch: pitch,
                           interval: interval,
                           proxySize: proxySize)
                .padding([.top, .bottom], topBottomPadding)
        }
    }
    
    struct AllSymbolsView: View {
        var viewConductor: ViewConductor
        var pitch: Pitch
        var interval: Interval
        var proxySize: CGSize

        var whichIntervalLabels: [IntervalLabelChoice: Bool] {
            viewConductor.intervalLabels[viewConductor.layoutChoice]!
        }
        
        var whichNoteLabels: [NoteLabelChoice: Bool] {
            viewConductor.noteLabels[viewConductor.layoutChoice]!
        }
        
        func symbolLength(_ size: CGSize) -> CGFloat {
            return minDimension(size) * interval.consonanceDissonance.symbolLength/* * (isSmall ? 1.25 : 1.0)*/
        }
        
        func maxSymbolLength(_ size: CGSize) -> CGFloat {
            return minDimension(size) * interval.consonanceDissonance.maxSymbolLength/* * (isSmall ? 1.25 : 1.0)*/
        }
        
        func minDimension(_ size: CGSize) -> CGFloat {
            return min(size.width, size.height)
        }
        
        var textColor: Color {
            switch viewConductor.paletteChoice {
            case .ebonyIvory:
                return pitch.accidental ? Color(viewConductor.creamColor) : Color(viewConductor.brownColor)
            default:
                return symbolColor
            }
        }

        var activated: Bool {
            return pitch.midiState == .on
        }
        
        var symbolColor: Color {
            let activeColor: Color
            let inactiveColor: Color

            switch viewConductor.paletteChoice {
            case .subtle:
                activeColor = Color(viewConductor.mainColor)
                inactiveColor = Color(interval.majorMinor.color)
            case .loud:
                activeColor = Color(interval.majorMinor.color)
                inactiveColor = Color(viewConductor.mainColor)
            case .ebonyIvory:
                inactiveColor = Color(pitch.accidental ? interval.majorMinor.color : interval.majorMinor.colorOnWhite)
                activeColor = inactiveColor
            }
            return activated ? activeColor : inactiveColor
        }
        
        var keySymbol: any Shape {
            return interval.consonanceDissonance.symbol
        }

        var body: some View {
            let labelPadding: CGFloat = 2.0
            let anyIntervalLabels: Bool = whichIntervalLabels.filter({ $0.key != IntervalLabelChoice.symbol}).values.contains(true)
            let anyNoteLabels: Bool = whichNoteLabels.filter({ $0.key != .octave}).values.contains(true)
            
            VStack(spacing: 0) {
                if viewConductor.layoutChoice == .piano {
                    Color.clear
                    Color.clear
                    Color.clear
                }
                if anyNoteLabels || viewConductor.showSymbols {
                    VStack(spacing: 1.0) {
                        if viewConductor.noteLabels[viewConductor.layoutChoice]![.letter]! {
                            Color.clear.overlay(
                                Text("\(pitch.letter(viewConductor.accidentalChoice()))\(octave)")
                            )
                        }
                        if viewConductor.noteLabels[viewConductor.layoutChoice]![.fixedDo]! {
                            Color.clear.overlay(
                                Text("\(pitch.fixedDo(viewConductor.accidentalChoice()))\(octave)")
                            )
                        }
                        if viewConductor.noteLabels[viewConductor.layoutChoice]![.month]! {
                            Color.clear.overlay(
                                Text("\(Calendar.current.shortMonthSymbols[(pitch.pitchClass.intValue + 3) % 12].capitalized)\(octave)")
                            )
                        }
                        if viewConductor.noteLabels[viewConductor.layoutChoice]![.midi]! {
                            Color.clear.overlay(
                                Text(String(pitch.midi))
                            )
                        }
                        if viewConductor.noteLabels[viewConductor.layoutChoice]![.frequency]! {
                            Color.clear.overlay(
                                Text(pow(2, CGFloat(pitch.midi - 69) / 12.0) * 440.0,
                                     format: .number.notation(.compactName).precision(.fractionLength(1)))
                            )
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding(labelPadding)
                }
                
                if viewConductor.showSymbols {
                    let symbolAdjustedLength = symbolLength(proxySize)
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            ZStack {
                                Color.clear
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(width: maxSymbolLength(proxySize))
                                    .overlay(
                                        AnyShape(keySymbol)
                                            .stroke(textColor, lineWidth: viewConductor.paletteChoice == .ebonyIvory ? symbolAdjustedLength * 0.1 : 0.0)
                                            .fill(symbolColor)
                                            .aspectRatio(1.0, contentMode: .fit)
                                            .frame(width: symbolAdjustedLength)
                                    )
                            }
                        }
                    }
                    .frame(height: maxSymbolLength(proxySize))
                }
                
                if anyIntervalLabels  || viewConductor.showSymbols {
                    VStack(spacing: 1.0) {
                        if viewConductor.intervalLabels[viewConductor.layoutChoice]![.interval]! {
                            Color.clear.overlay(
                                Text(String(interval.interval))
                            )
                        }
                        if viewConductor.intervalLabels[viewConductor.layoutChoice]![.movableDo]! {
                            Color.clear.overlay(
                                Text(interval.movableDo)
                            )
                        }
                        if viewConductor.intervalLabels[viewConductor.layoutChoice]![.roman]! {
                            Color.clear.overlay(
                                Text(String(interval.roman))
                            )
                        }
                        if viewConductor.intervalLabels[viewConductor.layoutChoice]![.degree]! {
                            Color.clear.overlay(
                                Text(String(interval.degree))
                            )
                        }
                        if viewConductor.intervalLabels[viewConductor.layoutChoice]![.integer]! {
                            Color.clear.overlay(
                                Text(String(interval.semitones))
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
            viewConductor.noteLabels[viewConductor.layoutChoice]![.octave]! ? String(pitch.octave) : ""
        }
    }
}
