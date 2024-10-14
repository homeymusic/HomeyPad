import SwiftUI
import HomeyMusicKit

public struct KeyboardKeyLabelView: View {
    var keyboardKey: KeyboardKeyView
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
                Labels(keyboardKey: keyboardKey, proxySize: proxySize, rotation: Angle.degrees(180))
                    .padding([.top, .bottom], topBottomPadding + tritonePadding)
            } else {
                Labels(keyboardKey: keyboardKey, proxySize: proxySize)
                    .padding([.top, .bottom], 0.5 * keyboardKey.backgroundBorderSize + tritonePadding)
            }
        }
    }
    
    struct Labels: View {
        let keyboardKey: KeyboardKeyView
        let proxySize: CGSize
        var rotation: Angle = .degrees(0)
        
        var body: some View {
            VStack(spacing: 2) {
                if keyboardKey.conductor.layoutChoice == .piano {
                    pianoLayoutSpacer
                }
                VStack(spacing: 1) {
                    noteLabels
                    modeLabel
                    plotIconLabel
                    monthLabel
                    symbolIcon
                    intervalLabels
                }
            }
            .padding(2.0)
            .foregroundColor(textColor)
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            .symbolEffect(.bounce, value: keyboardKey.pitch.timesAsTonic)
        }
        
        var pianoLayoutSpacer: some View {
            VStack(spacing: 0) {
                Color.clear
            }
            .frame(height: 0.55 * proxySize.height)
        }
        
        var noteLabels: some View {
            Group {
                if keyboardKey.conductor.noteLabel[.letter]! {
                    overlayText("\(keyboardKey.pitch.letter(keyboardKey.conductor.accidental))\(octave)")
                }
                if keyboardKey.conductor.noteLabel[.fixedDo]! {
                    overlayText("\(keyboardKey.pitch.fixedDo(keyboardKey.conductor.accidental))\(octave)")
                }
                if keyboardKey.conductor.noteLabel[.midi]! {
                    overlayText(String(keyboardKey.pitch.midi))
                }
                if keyboardKey.conductor.noteLabel[.wavelength]! {
                    overlayText("\(keyboardKey.pitch.wavelength.formatted(.number.notation(.compactName).precision(.significantDigits(3))))m")
                }
                if keyboardKey.conductor.noteLabel[.wavenumber]! {
                    overlayText("\(keyboardKey.pitch.wavenumber.formatted(.number.notation(.compactName).precision(.significantDigits(3))))m⁻¹")
                }
                if keyboardKey.conductor.noteLabel[.period]! {
                    overlayText("\((keyboardKey.pitch.period * 1000.0).formatted(.number.notation(.compactName).precision(.significantDigits(4))))ms")
                }
                if keyboardKey.conductor.noteLabel[.frequency]! {
                    overlayText("\(keyboardKey.pitch.frequency.formatted(.number.notation(.compactName).precision(.significantDigits(3))))Hz")
                }
                if keyboardKey.conductor.noteLabel[.cochlea]! {
                    overlayText("\(keyboardKey.pitch.cochlea.formatted(.number.notation(.compactName).precision(.significantDigits(3))))%")
                }
            }
        }
        
        var modeLabel: some View {
            if keyboardKey.conductor.noteLabel[.mode]! {
                return AnyView(
                    HStack(spacing: 0.0) {
                        Color.clear.overlay(
                            HStack(spacing: 1.0) {
                                Text(keyboardKey.pitch.mode.shortHand)
                                    .foregroundColor(Color(keyboardKey.pitch.mode.majorMinor.color))
                            }
                                .padding(2.0)
                                .background(Color(keyboardKey.conductor.brownColor))
                                .cornerRadius(3.0)
                        )
                    }
                )
            }
            return AnyView(EmptyView())
        }
        
        var plotIconLabel: some View {
            if keyboardKey.conductor.noteLabel[.plot]! {
                return AnyView(
                    HStack(spacing: 0.0) {
                        Color.clear.overlay(
                            HStack(spacing: 1.0) {
                                plotIconImages
                            }
                                .aspectRatio(keyboardKey.pitch.mode.scale == .pentatonic ? 3.0 : 2.0, contentMode: .fit)
                                .padding(2.0)
                                .background(Color(keyboardKey.conductor.brownColor))
                                .cornerRadius(3.0)
                        )
                    }
                )
            }
            return AnyView(EmptyView())
        }
        
        var plotIconImages: some View {
            Group {
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
                if keyboardKey.pitch.mode.scale == .pentatonic {
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
            }
        }
        
        var monthLabel: some View {
            if keyboardKey.conductor.noteLabel[.month]! {
                return AnyView(
                    Color.clear.overlay(
                        Text("\(Calendar.current.shortMonthSymbols[(keyboardKey.pitch.pitchClass.intValue + 3) % 12].capitalized)\(octave)")
                    )
                )
            }
            return AnyView(EmptyView())
        }
        
        var symbolIcon: some View {
            if keyboardKey.conductor.showSymbols {
                return if keyboardKey.isTonicOrOctave {
                    AnyView(
                        Color.clear.overlay(
                            Image(keyIcon)
                                .resizable()
                                .rotationEffect(rotation)
                                .scaledToFit()
                                .font(Font.system(size: .leastNormalMagnitude, weight: keyboardKey.interval.consonanceDissonance.fontWeight))
                                .frame(maxWidth: (keyboardKey.isSmall ? 0.6 : 0.5) * keyboardKey.interval.consonanceDissonance.imageScale * proxySize.width,
                                       maxHeight: 0.8 * keyboardKey.interval.consonanceDissonance.imageScale * proxySize.height / CGFloat(keyboardKey.conductor.labelsCount))
                        )
                    )
                    
                } else {
                    AnyView(
                        Color.clear.overlay(
                            Image(systemName: keyIcon)
                                .resizable()
                                .rotationEffect(rotation)
                                .scaledToFit()
                                .font(Font.system(size: .leastNormalMagnitude, weight: keyboardKey.interval.consonanceDissonance.fontWeight))
                                .frame(maxWidth: (keyboardKey.isSmall ? 0.6 : 0.5) * keyboardKey.interval.consonanceDissonance.imageScale * proxySize.width,
                                       maxHeight: 0.8 * keyboardKey.interval.consonanceDissonance.imageScale * proxySize.height / CGFloat(keyboardKey.conductor.labelsCount))
                        )
                    )
                }
            }
            return AnyView(EmptyView())
        }
        
        var intervalLabels: some View {
            Group {
                if keyboardKey.conductor.intervalLabel[.interval]! {
                    overlayText(String(keyboardKey.interval.classShorthand(globalPitchDirection: keyboardKey.conductor.pitchDirection)))
                }
                if keyboardKey.conductor.intervalLabel[.movableDo]! {
                    overlayText(keyboardKey.interval.movableDo)
                }
                if keyboardKey.conductor.intervalLabel[.roman]! {
                    overlayText(String(keyboardKey.interval.roman(globalPitchDirection: keyboardKey.conductor.pitchDirection)))
                }
                if keyboardKey.conductor.intervalLabel[.degree]! {
                    overlayText(String(keyboardKey.interval.degree(globalPitchDirection: keyboardKey.conductor.pitchDirection)))
                }
                if keyboardKey.conductor.intervalLabel[.integer]! {
                    overlayText(String(keyboardKey.interval.semitones))
                }
                if keyboardKey.conductor.intervalLabel[.wavelengthRatio]! {
                    overlayText(String(keyboardKey.interval.wavelengthRatio))
                }
                if keyboardKey.conductor.intervalLabel[.wavenumberRatio]! {
                    overlayText(String(keyboardKey.interval.wavenumberRatio))
                }
                if keyboardKey.conductor.intervalLabel[.periodRatio]! {
                    overlayText(String(keyboardKey.interval.periodRatio))
                }
                if keyboardKey.conductor.intervalLabel[.frequencyRatio]! {
                    overlayText(String(keyboardKey.interval.frequencyRatio))
                }
            }
        }
        
        func overlayText(_ text: String) -> some View {
            Color.clear.overlay(
                Text(text)
            )
        }
        
        func minDimension(_ size: CGSize) -> CGFloat {
            return min(size.width, size.height)
        }
        
        var textColor: Color {
            let activeColor: Color
            let inactiveColor: Color
            switch keyboardKey.conductor.paletteChoice {
            case .subtle:
                if keyboardKey.conductor.outlineChoice && keyboardKey.isTonicTonic {
                    activeColor = Color(keyboardKey.interval.majorMinor.color)
                    inactiveColor = Color(keyboardKey.conductor.mainColor)
                } else {
                    activeColor = Color(keyboardKey.conductor.mainColor)
                    inactiveColor = Color(keyboardKey.interval.majorMinor.color)
                }
            case .loud:
                if keyboardKey.conductor.outlineChoice && keyboardKey.isTonicTonic {
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

