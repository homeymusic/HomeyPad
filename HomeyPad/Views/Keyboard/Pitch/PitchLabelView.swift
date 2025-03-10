import SwiftUI
import HomeyMusicKit

public struct PitchLabelView: View {
    var pitchView: PitchView
    var proxySize: CGSize
    
    @EnvironmentObject var tonalContext: TonalContext
    @EnvironmentObject var instrumentalContext: InstrumentalContext
    @EnvironmentObject var notationalContext: NotationalContext

    public var body: some View {
        let diamondPadding: CGFloat = pitchView.containerType == .diamond ? 0.0 : 0.5 * DiamantiView.tritoneLength(proxySize: proxySize)
        let topBottomPadding = pitchView.outline ? 0.0 : 0.5 * pitchView.outlineHeight
        let extraPadding = diamondPadding + topBottomPadding
        return VStack(spacing: 0.0) {
            if pitchView.containerType == .span {
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
        
        @EnvironmentObject var tonalContext: TonalContext
        @EnvironmentObject var instrumentalContext: InstrumentalContext
        @EnvironmentObject var notationalContext: NotationalContext
        @EnvironmentObject var notationalTonicContext: NotationalTonicContext

        var thisNotationalContext: NotationalContext {
            pitchView.containerType == .tonicPicker ? notationalTonicContext : notationalContext
        }
        
        var body: some View {
            
            if pitchView.containerType == .tonicPicker {
                
            }
            
            
            VStack(spacing: 2) {
                if instrumentalContext.instrumentType == .piano && pitchView.containerType != .tonicPicker {
                    pianoLayoutSpacer
                }
                VStack(spacing: 1) {
                    noteLabels
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
            .frame(height: proxySize.height / HomeyPad.goldenRatio)
        }
        
        var noteLabels: some View {
            AnyView(
                Group {
                    if showNoteLabel(for: .letter) {
                        overlayText("\(pitchView.pitch.letter(using: tonalContext.accidental))\(octave)")
                    } else {
                        EmptyView()
                    }
                    if showNoteLabel(for: .fixedDo) {
                        overlayText("\(pitchView.pitch.fixedDo(using: tonalContext.accidental))\(octave)")
                    } else {
                        EmptyView()
                    }
                    if showNoteLabel(for: .month) {
                        overlayText("\(Calendar.current.shortMonthSymbols[(pitchView.pitch.pitchClass.intValue + 3) % 12].capitalized)\(octave)")
                    } else {
                        EmptyView()
                    }
                    if showNoteLabel(for: .midi) {
                        overlayText(String(pitchView.pitch.midiNote.number))
                    } else {
                        EmptyView()
                    }
                    if showNoteLabel(for: .wavelength) {
                        overlayText("\("λ") \(pitchView.pitch.wavelength.formatted(.number.notation(.compactName).precision(.significantDigits(3))))m")
                    } else {
                        EmptyView()
                    }
                    if showNoteLabel(for: .wavenumber) {
                        overlayText("\("k") \(pitchView.pitch.wavenumber.formatted(.number.notation(.compactName).precision(.significantDigits(3))))m⁻¹")
                    } else {
                        EmptyView()
                    }
                    if showNoteLabel(for: .period) {
                        overlayText("\("T") \((pitchView.pitch.fundamentalPeriod * 1000.0).formatted(.number.notation(.compactName).precision(.significantDigits(4))))ms")
                    } else {
                        EmptyView()
                    }
                    if showNoteLabel(for: .frequency) {
                        overlayText("\("f") \(pitchView.pitch.fundamentalFrequency.formatted(.number.notation(.compactName).precision(.significantDigits(3))))Hz")
                    } else {
                        EmptyView()
                    }
                    if showNoteLabel(for: .cochlea) {
                        overlayText("\(pitchView.pitch.cochlea.formatted(.number.notation(.compactName).precision(.significantDigits(3))))%")
                    } else {
                        EmptyView()
                    }
                }
            )
        }
        
        var symbolIcon: some View {
            if showIntervalLabel(for: .symbol) {
                return AnyView(
                    Color.clear.overlay(
                        pitchView.pitchInterval.consonanceDissonance.image
                            .resizable()
                            .rotationEffect(rotation)
                            .scaledToFit()
                            .font(Font.system(size: .leastNormalMagnitude,
                                              weight: pitchView.pitchInterval.consonanceDissonance.fontWeight))
                            .frame(maxWidth: (pitchView.isSmall ? 0.6 : 0.5) *
                                   pitchView.pitchInterval.consonanceDissonance.imageScale * proxySize.width,
                                   maxHeight: 0.8 *
                                   pitchView.pitchInterval.consonanceDissonance.imageScale * proxySize.height /
                                   CGFloat(notationalContext.labelsCount(for: instrumentalContext.instrumentType)))
                            .scaleEffect(pitchView.pitchInterval.isTonic ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3),
                                       value: pitchView.pitchInterval.isTonic)
                    )
                )
            }
            return AnyView(EmptyView())
        }
        
        var intervalLabels: some View {
            return Group {
                if showIntervalLabel(for: .interval) {
                    overlayText(String(pitchView.pitchInterval.intervalClass.shorthand(for: tonalContext.pitchDirection)))
                }
                if showIntervalLabel(for: .roman) {
                    overlayText(String(pitchView.pitchInterval.roman(pitchDirection: tonalContext.pitchDirection)))
                }
                if showIntervalLabel(for: .degree) {
                    overlayText(String(pitchView.pitchInterval.degree(pitchDirection: tonalContext.pitchDirection)))
                }
                if showIntervalLabel(for: .integer) {
                    overlayText(String(pitchView.pitchInterval.distance))
                }
                if showIntervalLabel(for: .movableDo) {
                    overlayText(pitchView.pitchInterval.movableDo)
                }
                if showIntervalLabel(for: .wavelengthRatio) {
                    overlayText(String(pitchView.pitchInterval.wavelengthRatio))
                }
                if showIntervalLabel(for: .wavenumberRatio) {
                    overlayText(String(pitchView.pitchInterval.wavenumberRatio))
                }
                if showIntervalLabel(for: .periodRatio) {
                    overlayText(String(pitchView.pitchInterval.periodRatio))
                }
                if showIntervalLabel(for: .frequencyRatio) {
                    overlayText(String(pitchView.pitchInterval.frequencyRatio))
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
        
        var isActivated: Bool {
            pitchView.containerType == .tonicPicker ?
            pitchView.pitch.pitchClass.isActivated(in: tonalContext.activatedPitches) :
            pitchView.pitch.isActivated
        }
        
        var textColor: Color {
            let activeColor: Color
            let inactiveColor: Color
            switch notationalContext.colorPalette[instrumentalContext.instrumentType]! {
            case .subtle:
                activeColor = Color(HomeyPad.primaryColor)
                inactiveColor = Color(pitchView.pitchInterval.majorMinor.color)
            case .loud:
                activeColor = Color(pitchView.pitchInterval.majorMinor.color)
                inactiveColor = Color(HomeyPad.primaryColor)
            case .ebonyIvory:
                return pitchView.pitch.isNatural ? .black : .white
            }
            return isActivated ? activeColor : inactiveColor
        }
        
        var octave: String {
            thisNotationalContext.noteLabels[instrumentalContext.instrumentType]![.octave]! ? String(pitchView.pitch.octave) : ""
        }
        
        func showNoteLabel(for key: NoteLabelChoice) -> Bool {
            if pitchView.containerType == .tonicPicker {
                return notationalTonicContext.noteLabels[.tonicPicker]![key]!
            } else {
                return notationalContext.noteLabels[instrumentalContext.instrumentType]![key]!
            }
        }
        
        func showIntervalLabel(for key: IntervalLabelChoice) -> Bool {
            if pitchView.containerType == .tonicPicker {
                return notationalTonicContext.intervalLabels[.tonicPicker]![key]!
            } else {
                return notationalContext.intervalLabels[instrumentalContext.instrumentType]![key]!
            }
        }

    }
}
