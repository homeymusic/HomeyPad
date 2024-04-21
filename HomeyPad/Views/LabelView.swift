import SwiftUI

public struct LabelView: View {
    var keyboardKey: KeyboardKey
    var proxySize: CGSize
    
    var isSymmetricNotTritone: Bool {
        keyboardKey.conductor.layoutChoice == .symmetric && keyboardKey.interval.intervalClass != .six
    }
    
    public var body: some View {
        let tritonePadding: CGFloat = isSymmetricNotTritone ? 0.5 * ViewConductor.currentTritoneLength - 1.5 * keyboardKey.backgroundBorderSize : 0.0
        VStack(spacing: 0.0) {
            if keyboardKey.conductor.layoutChoice == .symmetric && keyboardKey.interval.consonanceDissonance > .consonant {
                let topBottomPadding = (keyboardKey.outline ? 0.0 : 0.5 * keyboardKey.backgroundBorderSize)
                Labels(keyboardKey: keyboardKey, proxySize: proxySize)
                    .padding([.top, .bottom], topBottomPadding + tritonePadding)
                Color.clear
                    .frame(height: keyboardKey.outline ? 2 * keyboardKey.backgroundBorderSize : keyboardKey.backgroundBorderSize)
                Labels(keyboardKey: keyboardKey, proxySize: proxySize)
                    .padding([.top, .bottom], topBottomPadding + tritonePadding)
            } else {
                Labels(keyboardKey: keyboardKey, proxySize: proxySize)
                    .padding([.top, .bottom], 0.5 * keyboardKey.backgroundBorderSize + tritonePadding)
            }
        }
    }
    
    struct Labels: View {
        var keyboardKey: KeyboardKey
        var proxySize: CGSize
        
        var body: some View {
            VStack(spacing: 2) {
                if keyboardKey.conductor.layoutChoice == .piano {
                    VStack(spacing: 0) {
                        Color.clear
                    }
                    .frame(height: 0.55 * proxySize.height)
                }
                VStack(spacing: 0) {
                    if keyboardKey.conductor.noteLabel[.letter]! {
                        Color.clear.overlay(
                            Text("\(keyboardKey.pitch.letter(keyboardKey.conductor.accidentalChoice))\(octave)")
                        )
                    }
                    if keyboardKey.conductor.noteLabel[.fixedDo]! {
                        Color.clear.overlay(
                            Text("\(keyboardKey.pitch.fixedDo(keyboardKey.conductor.accidentalChoice))\(octave)")
                        )
                    }
                    if keyboardKey.conductor.noteLabel[.midi]! {
                        Color.clear.overlay(
                            Text(String(keyboardKey.pitch.midi))
                        )
                    }
                    if keyboardKey.conductor.noteLabel[.frequency]! {
                        Color.clear.overlay(
                            Text("\(keyboardKey.pitch.frequency.formatted(.number.notation(.compactName).precision(.significantDigits(3))))Hz")
                        )
                    }
                    if keyboardKey.conductor.noteLabel[.period]! {
                        Color.clear.overlay(
                            Text("\((keyboardKey.pitch.period * 1000.0).formatted(.number.notation(.compactName).precision(.significantDigits(4))))ms")
                        )
                    }
                    if keyboardKey.conductor.noteLabel[.wavelength]! {
                        Color.clear.overlay(
                            Text("\(keyboardKey.pitch.wavelength.formatted(.number.notation(.compactName).precision(.significantDigits(3))))m")
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
                                    if (keyboardKey.pitch.mode.scale == .pentatonic) {
                                        Image(systemName: "square")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.clear)
                                            .overlay(
                                                Image(systemName: Scale.pentatonic.icon)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundColor(Color(keyboardKey.pitch.mode.majorMinor.color))
                                            )
                                    }
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
                                    .aspectRatio(keyboardKey.pitch.mode.scale == .pentatonic ? 3.0 : 2.0, contentMode: .fit)
                                    .padding(2.0)
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
                        Color.clear
                            .overlay(
                                Image(systemName: keyIcon)
                                    .resizable()
                                    .scaledToFit()
                                    .font(Font.system(size: .leastNormalMagnitude, weight: keyboardKey.interval.consonanceDissonance.fontWeight))
                                    .frame(maxWidth: (keyboardKey.isSmall ? 0.6 : 0.5) * keyboardKey.interval.consonanceDissonance.imageScale * proxySize.width,
                                           maxHeight: 0.8 * keyboardKey.interval.consonanceDissonance.imageScale * proxySize.height / CGFloat(keyboardKey.conductor.labelsCount))
                            )
                    }
                    if keyboardKey.conductor.intervalLabel[.interval]! {
                        Color.clear.overlay(
                            Text(String(keyboardKey.interval.classShorthand(globalPitchDirection: keyboardKey.conductor.pitchDirection)))
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
            .symbolEffect(.bounce, value: keyboardKey.pitch.timesAsTonic)
        }
        
        func minDimension(_ size: CGSize) -> CGFloat {
            return min(size.width, size.height)
        }
        
        var textColor: Color {
            let activeColor: Color
            let inactiveColor: Color
            switch keyboardKey.conductor.paletteChoice {
            case .subtle:
                if keyboardKey.conductor.outlineChoice && keyboardKey.tonicTonic {
                    activeColor = Color(keyboardKey.interval.majorMinor.color)
                    inactiveColor = Color(keyboardKey.conductor.mainColor)
                } else {
                    activeColor = Color(keyboardKey.conductor.mainColor)
                    inactiveColor = Color(keyboardKey.interval.majorMinor.color)
                }
            case .loud:
                if keyboardKey.conductor.outlineChoice && keyboardKey.tonicTonic {
                    activeColor = Color(keyboardKey.conductor.mainColor)
                    inactiveColor = Color(keyboardKey.interval.majorMinor.color)
                } else {
                    activeColor = Color(keyboardKey.interval.majorMinor.color)
                    inactiveColor = Color(keyboardKey.conductor.mainColor)
                }
            case .ebonyIvory:
                return keyboardKey.pitch.accidental ? .white : .black
            }
            return keyboardKey.activated ? activeColor : inactiveColor
        }
        
        var keyIcon: String {
            return keyboardKey.interval.consonanceDissonance.icon
        }
        
        var octave: String {
            keyboardKey.conductor.noteLabel[.octave]! ? String(keyboardKey.pitch.octave) : ""
        }
        
    }
}

