import SwiftUI
import HomeyMusicKit

public struct KeyboardKeyLabelView: View {
    var keyboardKeyView: KeyboardKeyView
    var proxySize: CGSize
    
    var isSymmetricNotTritone: Bool {
        keyboardKeyView.conductor.layoutChoice == .symmetric && keyboardKeyView.interval.intervalClass != .six
    }
    
    public var body: some View {
        let tritonePadding: CGFloat = isSymmetricNotTritone ? 0.5 * ViewConductor.currentTritoneLength - 1.5 * keyboardKeyView.backgroundBorderSize : 0.0
        VStack(spacing: 0.0) {
            if keyboardKeyView.conductor.layoutChoice == .symmetric && keyboardKeyView.interval.consonanceDissonance > .consonant {
                let topBottomPadding = (keyboardKeyView.outline ? 0.0 : 0.5 * keyboardKeyView.backgroundBorderSize)
                Labels(keyboardKeyView: keyboardKeyView, proxySize: proxySize)
                    .padding([.top, .bottom], topBottomPadding + tritonePadding)
                Color.clear
                    .frame(height: keyboardKeyView.outline ? 2 * keyboardKeyView.backgroundBorderSize : keyboardKeyView.backgroundBorderSize)
                Labels(keyboardKeyView: keyboardKeyView, proxySize: proxySize, rotation: Angle.degrees(180))
                    .padding([.top, .bottom], topBottomPadding + tritonePadding)
            } else {
                Labels(keyboardKeyView: keyboardKeyView, proxySize: proxySize)
                    .padding([.top, .bottom], 0.5 * keyboardKeyView.backgroundBorderSize + tritonePadding)
            }
        }
    }
    
    struct Labels: View {
        let keyboardKeyView: KeyboardKeyView
        let proxySize: CGSize
        var rotation: Angle = .degrees(0)
        
        var body: some View {
            VStack(spacing: 2) {
                if keyboardKeyView.conductor.layoutChoice == .piano {
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
            .symbolEffect(.bounce, value: keyboardKeyView.pitch.timesAsTonic)
        }
        
        var pianoLayoutSpacer: some View {
            VStack(spacing: 0) {
                Color.clear
            }
            .frame(height: 0.55 * proxySize.height)
        }
        
        var noteLabels: some View {
            Group {
                if keyboardKeyView.conductor.noteLabel[.letter]! {
                    overlayText("\(keyboardKeyView.pitch.letter(keyboardKeyView.conductor.accidental))\(octave)")
                }
                if keyboardKeyView.conductor.noteLabel[.fixedDo]! {
                    overlayText("\(keyboardKeyView.pitch.fixedDo(keyboardKeyView.conductor.accidental))\(octave)")
                }
                if keyboardKeyView.conductor.noteLabel[.midi]! {
                    overlayText(String(keyboardKeyView.pitch.midi))
                }
                if keyboardKeyView.conductor.noteLabel[.wavelength]! {
                    overlayText("\(keyboardKeyView.pitch.wavelength.formatted(.number.notation(.compactName).precision(.significantDigits(3))))m")
                }
                if keyboardKeyView.conductor.noteLabel[.wavenumber]! {
                    overlayText("\(keyboardKeyView.pitch.wavenumber.formatted(.number.notation(.compactName).precision(.significantDigits(3))))m⁻¹")
                }
                if keyboardKeyView.conductor.noteLabel[.period]! {
                    overlayText("\((keyboardKeyView.pitch.period * 1000.0).formatted(.number.notation(.compactName).precision(.significantDigits(4))))ms")
                }
                if keyboardKeyView.conductor.noteLabel[.frequency]! {
                    overlayText("\(keyboardKeyView.pitch.frequency.formatted(.number.notation(.compactName).precision(.significantDigits(3))))Hz")
                }
                if keyboardKeyView.conductor.noteLabel[.cochlea]! {
                    overlayText("\(keyboardKeyView.pitch.cochlea.formatted(.number.notation(.compactName).precision(.significantDigits(3))))%")
                }
            }
        }
        
        var modeLabel: some View {
            if keyboardKeyView.conductor.noteLabel[.mode]! {
                return AnyView(
                    HStack(spacing: 0.0) {
                        Color.clear.overlay(
                            HStack(spacing: 1.0) {
                                Text(keyboardKeyView.pitch.mode.shortHand)
                                    .foregroundColor(Color(keyboardKeyView.pitch.mode.majorMinor.color))
                            }
                                .padding(2.0)
                                .background(Color(keyboardKeyView.conductor.brownColor))
                                .cornerRadius(3.0)
                        )
                    }
                )
            }
            return AnyView(EmptyView())
        }
        
        var plotIconLabel: some View {
            if keyboardKeyView.conductor.noteLabel[.plot]! {
                return AnyView(
                    HStack(spacing: 0.0) {
                        Color.clear.overlay(
                            HStack(spacing: 1.0) {
                                plotIconImages
                            }
                                .aspectRatio(keyboardKeyView.pitch.mode.scale == .pentatonic ? 3.0 : 2.0, contentMode: .fit)
                                .padding(2.0)
                                .background(Color(keyboardKeyView.conductor.brownColor))
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
                        Image(systemName: keyboardKeyView.pitch.mode.pitchDirection.icon)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(keyboardKeyView.pitch.mode.pitchDirection.majorMinor.color))
                    )
                Image(systemName: "square")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.clear)
                    .overlay(
                        Image(systemName: keyboardKeyView.pitch.mode.chordShape.icon)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(keyboardKeyView.pitch.mode.chordShape.majorMinor.color))
                    )
                if keyboardKeyView.pitch.mode.scale == .pentatonic {
                    Image(systemName: "square")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.clear)
                        .overlay(
                            Image(systemName: Scale.pentatonic.icon)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(keyboardKeyView.pitch.mode.majorMinor.color))
                        )
                }
            }
        }
        
        var monthLabel: some View {
            if keyboardKeyView.conductor.noteLabel[.month]! {
                return AnyView(
                    Color.clear.overlay(
                        Text("\(Calendar.current.shortMonthSymbols[(keyboardKeyView.pitch.pitchClass.intValue + 3) % 12].capitalized)\(octave)")
                    )
                )
            }
            return AnyView(EmptyView())
        }
        
        var symbolIcon: some View {
            if keyboardKeyView.conductor.showSymbols {
                return if keyboardKeyView.interval.isTonicOrOctave {
                    AnyView(
                        Color.clear.overlay(
                            keyboardKeyView.interval.consonanceDissonance.image
                                .resizable()
                                .rotationEffect(rotation)
                                .scaledToFit()
                                .font(Font.system(size: .leastNormalMagnitude, weight: keyboardKeyView.interval.consonanceDissonance.fontWeight))
                                .frame(maxWidth: (keyboardKeyView.isSmall ? 0.6 : 0.5) * keyboardKeyView.interval.consonanceDissonance.imageScale * proxySize.width,
                                       maxHeight: 0.8 * keyboardKeyView.interval.consonanceDissonance.imageScale * proxySize.height / CGFloat(keyboardKeyView.conductor.labelsCount))
                        )
                    )
                    
                } else {
                    AnyView(
                        Color.clear.overlay(
                            keyboardKeyView.interval.consonanceDissonance.image
                                .resizable()
                                .rotationEffect(rotation)
                                .scaledToFit()
                                .font(Font.system(size: .leastNormalMagnitude, weight: keyboardKeyView.interval.consonanceDissonance.fontWeight))
                                .frame(maxWidth: (keyboardKeyView.isSmall ? 0.6 : 0.5) * keyboardKeyView.interval.consonanceDissonance.imageScale * proxySize.width,
                                       maxHeight: 0.8 * keyboardKeyView.interval.consonanceDissonance.imageScale * proxySize.height / CGFloat(keyboardKeyView.conductor.labelsCount))
                        )
                    )
                }
            }
            return AnyView(EmptyView())
        }
        
        var intervalLabels: some View {
            Group {
                if keyboardKeyView.conductor.intervalLabel[.interval]! {
                    overlayText(String(keyboardKeyView.interval.classShorthand))
                }
                if keyboardKeyView.conductor.intervalLabel[.movableDo]! {
                    overlayText(keyboardKeyView.interval.movableDo)
                }
                if keyboardKeyView.conductor.intervalLabel[.roman]! {
                    overlayText(String(keyboardKeyView.interval.roman))
                }
                if keyboardKeyView.conductor.intervalLabel[.degree]! {
                    overlayText(String(keyboardKeyView.interval.degree))
                }
                if keyboardKeyView.conductor.intervalLabel[.integer]! {
                    overlayText(String(keyboardKeyView.interval.semitones))
                }
                if keyboardKeyView.conductor.intervalLabel[.wavelengthRatio]! {
                    overlayText(String(keyboardKeyView.interval.wavelengthRatio))
                }
                if keyboardKeyView.conductor.intervalLabel[.wavenumberRatio]! {
                    overlayText(String(keyboardKeyView.interval.wavenumberRatio))
                }
                if keyboardKeyView.conductor.intervalLabel[.periodRatio]! {
                    overlayText(String(keyboardKeyView.interval.periodRatio))
                }
                if keyboardKeyView.conductor.intervalLabel[.frequencyRatio]! {
                    overlayText(String(keyboardKeyView.interval.frequencyRatio))
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
            switch keyboardKeyView.conductor.paletteChoice {
            case .subtle:
                if keyboardKeyView.conductor.outlineChoice && keyboardKeyView.isTonicTonic {
                    activeColor = Color(keyboardKeyView.interval.majorMinor.color)
                    inactiveColor = Color(keyboardKeyView.conductor.mainColor)
                } else {
                    activeColor = Color(keyboardKeyView.conductor.mainColor)
                    inactiveColor = Color(keyboardKeyView.interval.majorMinor.color)
                }
            case .loud:
                if keyboardKeyView.conductor.outlineChoice && keyboardKeyView.isTonicTonic {
                    activeColor = Color(keyboardKeyView.conductor.mainColor)
                    inactiveColor = Color(keyboardKeyView.interval.majorMinor.color)
                } else {
                    activeColor = Color(keyboardKeyView.interval.majorMinor.color)
                    inactiveColor = Color(keyboardKeyView.conductor.mainColor)
                }
            case .ebonyIvory:
                return keyboardKeyView.pitch.accidental ? .white : .black
            }
            return keyboardKeyView.activated ? activeColor : inactiveColor
        }
        
        var octave: String {
            keyboardKeyView.conductor.noteLabel[.octave]! ? String(keyboardKeyView.pitch.octave) : ""
        }
        
    }
}

