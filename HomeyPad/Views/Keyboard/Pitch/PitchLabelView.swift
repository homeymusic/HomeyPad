import SwiftUI
import HomeyMusicKit

public struct PitchLabelView: View {
    var pitchView: PitchView
    var proxySize: CGSize
    
    var isSymmetricNotTritone: Bool {
        pitchView.thisConductor.layoutChoice == .symmetric && !pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).isTritone
    }
    
    public var body: some View {
        let tritonePadding: CGFloat = isSymmetricNotTritone ? 0.5 * pitchView.thisConductor.tritoneLength(proxySize: proxySize) : 0.0
        let topBottomPadding = pitchView.outline ? 0.0 : 0.5 * pitchView.outlineHeight
        let extraPadding = tritonePadding + topBottomPadding
        VStack(spacing: 0.0) {
            if pitchView.thisConductor.layoutChoice == .symmetric && pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).consonanceDissonance > .consonant {
                Labels(pitchView: pitchView, proxySize: proxySize)
                    .padding([.top, .bottom], extraPadding)
                Color.clear
                    .frame(height: pitchView.outline ? 2 * pitchView.backgroundBorderSize : pitchView.backgroundBorderSize)
                Labels(pitchView: pitchView, proxySize: proxySize, rotation: Angle.degrees(180))
                    .padding([.top, .bottom], extraPadding)
            } else {
                Labels(pitchView: pitchView, proxySize: proxySize)
                    .padding([.top, .bottom], extraPadding)
            }
        }
    }
    
    struct Labels: View {
        let pitchView: PitchView
        let proxySize: CGSize
        var rotation: Angle = .degrees(0)
        
        var body: some View {
            VStack(spacing: 2) {
                if pitchView.thisConductor.layoutChoice == .piano {
                    pianoLayoutSpacer
                }
                VStack(spacing: 1) {
                    noteLabels
                    monthLabel
                    symbolIcon
                    intervalLabels
                }
            }
            .padding(2.0)
            .foregroundColor(textColor)
            .minimumScaleFactor(0.1)
            .lineLimit(1)
        }
        
        var pianoLayoutSpacer: some View {
            VStack(spacing: 0) {
                Color.clear
            }
            .frame(height: 0.55 * proxySize.height)
        }
        
        var noteLabels: some View {
            Group {
                if pitchView.thisConductor.noteLabel[.letter]! {
                    overlayText("\(pitchView.pitch.letter(pitchView.thisConductor.accidental))\(octave)")
                }
                if pitchView.thisConductor.noteLabel[.fixedDo]! {
                    overlayText("\(pitchView.pitch.fixedDo(pitchView.thisConductor.accidental))\(octave)")
                }
                if pitchView.thisConductor.noteLabel[.midi]! {
                    overlayText(String(pitchView.pitch.midiNote.number))
                }
                if pitchView.thisConductor.noteLabel[.wavelength]! {
                    overlayText("\("λ") \(pitchView.pitch.wavelength.formatted(.number.notation(.compactName).precision(.significantDigits(3))))m")
                }
                if pitchView.thisConductor.noteLabel[.wavenumber]! {
                    overlayText("\("k") \(pitchView.pitch.wavenumber.formatted(.number.notation(.compactName).precision(.significantDigits(3))))m⁻¹")
                }
                if pitchView.thisConductor.noteLabel[.period]! {
                    overlayText("\("T") \((pitchView.pitch.fundamentalPeriod * 1000.0).formatted(.number.notation(.compactName).precision(.significantDigits(4))))ms")
                }
                if pitchView.thisConductor.noteLabel[.frequency]! {
                    overlayText("\("f") \(pitchView.pitch.fundamentalFrequency.formatted(.number.notation(.compactName).precision(.significantDigits(3))))Hz")
                }
                if pitchView.thisConductor.noteLabel[.cochlea]! {
                    overlayText("\(pitchView.pitch.cochlea.formatted(.number.notation(.compactName).precision(.significantDigits(3))))%")
                }
            }
        }
                
        var monthLabel: some View {
            if pitchView.thisConductor.noteLabel[.month]! {
                return AnyView(
                    Color.clear.overlay(
                        Text("\(Calendar.current.shortMonthSymbols[(pitchView.pitch.pitchClass.intValue + 3) % 12].capitalized)\(octave)")
                    )
                )
            }
            return AnyView(EmptyView())
        }
        
        var symbolIcon: some View {
            if pitchView.thisConductor.showSymbols {
                return AnyView(
                    Color.clear.overlay(
                        pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).consonanceDissonance.image
                            .resizable()
                            .rotationEffect(rotation)
                            .scaledToFit()
                            .font(Font.system(size: .leastNormalMagnitude, weight: pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).consonanceDissonance.fontWeight))
                            .frame(maxWidth: (pitchView.isSmall ? 0.6 : 0.5) * pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).consonanceDissonance.imageScale * proxySize.width,
                                   maxHeight: 0.8 * pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).consonanceDissonance.imageScale * proxySize.height / CGFloat(pitchView.thisConductor.labelsCount))
                            .scaleEffect(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).isTonic ? 1.2 : 1.0) // Scale up for .tonic
                            .animation(.easeInOut(duration: 0.3), value: pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).isTonic) // Animate when interval becomes .tonic
                    )
                )
            }
            return AnyView(EmptyView())
        }
        
        var intervalLabels: some View {
            return Group {
                if pitchView.thisConductor.intervalLabel[.interval]! {
                    overlayText(String(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).intervalClass.shorthand(for: pitchView.tonalContext.pitchDirection
                                                                                                                                )))
                }
                if pitchView.thisConductor.intervalLabel[.roman]! {
                    overlayText(String(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).roman(pitchDirection: pitchView.tonalContext.pitchDirection)))
                }
                if pitchView.thisConductor.intervalLabel[.degree]! {
                    overlayText(String(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).degree(pitchDirection: pitchView.tonalContext.pitchDirection)))
                }
                if pitchView.thisConductor.intervalLabel[.integer]! {
                    overlayText(String(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).distance))
                }
                if pitchView.thisConductor.intervalLabel[.movableDo]! {
                    overlayText(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).movableDo)
                }
                if pitchView.thisConductor.intervalLabel[.wavelengthRatio]! {
                    overlayText(String(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).wavelengthRatio))
                }
                if pitchView.thisConductor.intervalLabel[.wavenumberRatio]! {
                    overlayText(String(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).wavenumberRatio))
                }
                if pitchView.thisConductor.intervalLabel[.periodRatio]! {
                    overlayText(String(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).periodRatio))
                }
                if pitchView.thisConductor.intervalLabel[.frequencyRatio]! {
                    overlayText(String(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).frequencyRatio))
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
        
        // Local variable to check activation based on layout
        var isActivated: Bool {
            pitchView.thisConductor.layoutChoice == .tonic ? pitchView.pitch.pitchClass.isActivated : pitchView.pitch.isActivated
        }
        
        
        var textColor: Color {
            let activeColor: Color
            let inactiveColor: Color
            switch pitchView.thisConductor.paletteChoice {
            case .subtle:
                activeColor = Color(pitchView.thisConductor.primaryColor)
                inactiveColor = Color(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).majorMinor.color)
            case .loud:
                activeColor = Color(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).majorMinor.color)
                inactiveColor = Color(pitchView.thisConductor.primaryColor)
            case .ebonyIvory:
                return pitchView.pitch.isNatural ? .black : .white
            }
            return isActivated ? activeColor : inactiveColor
        }
        
        var octave: String {
            pitchView.thisConductor.noteLabel[.octave]! ? String(pitchView.pitch.octave) : ""
        }
        
    }
}

