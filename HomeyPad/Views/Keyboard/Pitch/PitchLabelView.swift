import SwiftUI
import HomeyMusicKit

public struct PitchLabelView: View {
    var pitchView: PitchView
    var proxySize: CGSize
    
    var isSymmetricNotTritone: Bool {
        pitchView.conductor.layoutChoice == .symmetric && !pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).isTritone
    }
    
    public var body: some View {
        let tritonePadding: CGFloat = isSymmetricNotTritone ? 0.5 * pitchView.conductor.tritoneLength(proxySize: proxySize) : 0.0
        let topBottomPadding = pitchView.outline ? 0.0 : 0.5 * pitchView.outlineHeight
        let extraPadding = tritonePadding + topBottomPadding
        VStack(spacing: 0.0) {
            if pitchView.conductor.layoutChoice == .symmetric && pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).consonanceDissonance > .consonant {
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
                if pitchView.conductor.layoutChoice == .piano {
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
                if pitchView.conductor.noteLabel[.letter]! {
                    overlayText("\(pitchView.pitch.letter(pitchView.conductor.accidental))\(octave)")
                }
                if pitchView.conductor.noteLabel[.fixedDo]! {
                    overlayText("\(pitchView.pitch.fixedDo(pitchView.conductor.accidental))\(octave)")
                }
                if pitchView.conductor.noteLabel[.midi]! {
                    overlayText(String(pitchView.pitch.midiNote.number))
                }
                if pitchView.conductor.noteLabel[.wavelength]! {
                    overlayText("\("λ") \(pitchView.pitch.wavelength.formatted(.number.notation(.compactName).precision(.significantDigits(3))))m")
                }
                if pitchView.conductor.noteLabel[.wavenumber]! {
                    overlayText("\("k") \(pitchView.pitch.wavenumber.formatted(.number.notation(.compactName).precision(.significantDigits(3))))m⁻¹")
                }
                if pitchView.conductor.noteLabel[.period]! {
                    overlayText("\("T") \((pitchView.pitch.fundamentalPeriod * 1000.0).formatted(.number.notation(.compactName).precision(.significantDigits(4))))ms")
                }
                if pitchView.conductor.noteLabel[.frequency]! {
                    overlayText("\("f") \(pitchView.pitch.fundamentalFrequency.formatted(.number.notation(.compactName).precision(.significantDigits(3))))Hz")
                }
                if pitchView.conductor.noteLabel[.cochlea]! {
                    overlayText("\(pitchView.pitch.cochlea.formatted(.number.notation(.compactName).precision(.significantDigits(3))))%")
                }
            }
        }
                
        var monthLabel: some View {
            if pitchView.conductor.noteLabel[.month]! {
                return AnyView(
                    Color.clear.overlay(
                        Text("\(Calendar.current.shortMonthSymbols[(pitchView.pitch.pitchClass.intValue + 3) % 12].capitalized)\(octave)")
                    )
                )
            }
            return AnyView(EmptyView())
        }
        
        var symbolIcon: some View {
            if pitchView.conductor.showSymbols {
                return AnyView(
                    Color.clear.overlay(
                        pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).consonanceDissonance.image
                            .resizable()
                            .rotationEffect(rotation)
                            .scaledToFit()
                            .font(Font.system(size: .leastNormalMagnitude, weight: pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).consonanceDissonance.fontWeight))
                            .frame(maxWidth: (pitchView.isSmall ? 0.6 : 0.5) * pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).consonanceDissonance.imageScale * proxySize.width,
                                   maxHeight: 0.8 * pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).consonanceDissonance.imageScale * proxySize.height / CGFloat(pitchView.conductor.labelsCount))
                            .scaleEffect(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).isTonic ? 1.2 : 1.0) // Scale up for .tonic
                            .animation(.easeInOut(duration: 0.3), value: pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).isTonic) // Animate when interval becomes .tonic
                    )
                )
            }
            return AnyView(EmptyView())
        }
        
        var intervalLabels: some View {
            return Group {
                if pitchView.conductor.intervalLabel[.interval]! {
                    overlayText(String(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).intervalClass.shorthand(for: pitchView.tonalContext.pitchDirection
                                                                                                                                )))
                }
                if pitchView.conductor.intervalLabel[.roman]! {
                    overlayText(String(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).roman(pitchDirection: pitchView.tonalContext.pitchDirection)))
                }
                if pitchView.conductor.intervalLabel[.degree]! {
                    overlayText(String(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).degree(pitchDirection: pitchView.tonalContext.pitchDirection)))
                }
                if pitchView.conductor.intervalLabel[.integer]! {
                    overlayText(String(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).distance))
                }
                if pitchView.conductor.intervalLabel[.movableDo]! {
                    overlayText(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).movableDo)
                }
                if pitchView.conductor.intervalLabel[.wavelengthRatio]! {
                    overlayText(String(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).wavelengthRatio))
                }
                if pitchView.conductor.intervalLabel[.wavenumberRatio]! {
                    overlayText(String(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).wavenumberRatio))
                }
                if pitchView.conductor.intervalLabel[.periodRatio]! {
                    overlayText(String(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).periodRatio))
                }
                if pitchView.conductor.intervalLabel[.frequencyRatio]! {
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
            pitchView.conductor.layoutChoice == .tonic ? pitchView.pitch.pitchClass.isActivated : pitchView.pitch.isActivated
        }
        
        
        var textColor: Color {
            let activeColor: Color
            let inactiveColor: Color
            switch pitchView.conductor.paletteChoice {
            case .subtle:
                activeColor = Color(pitchView.conductor.primaryColor)
                inactiveColor = Color(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).majorMinor.color)
            case .loud:
                activeColor = Color(pitchView.pitch.interval(from: pitchView.tonalContext.tonicPitch).majorMinor.color)
                inactiveColor = Color(pitchView.conductor.primaryColor)
            case .ebonyIvory:
                return pitchView.pitch.isNatural ? .black : .white
            }
            return isActivated ? activeColor : inactiveColor
        }
        
        var octave: String {
            pitchView.conductor.noteLabel[.octave]! ? String(pitchView.pitch.octave) : ""
        }
        
    }
}

