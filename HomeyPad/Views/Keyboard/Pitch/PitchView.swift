import HomeyMusicKit
import SwiftUI

public struct PitchView: View {
    
    @ObservedObject var pitch: Pitch
    @ObservedObject var thisConductor: ViewConductor
    let containerType: ContainerType

    @EnvironmentObject var tonicConductor: ViewConductor
    @EnvironmentObject var viewConductor: ViewConductor
    @EnvironmentObject var modeConductor: ViewConductor

    @EnvironmentObject var tonalContext: TonalContext
    @EnvironmentObject var instrumentContext: InstrumentalContext

    var pitchInterval: Interval {
        return tonalContext.interval(fromTonicTo: pitch)
    }
    
    var borderWidthApparentSize: CGFloat {
        isSmall ? 2.0 * backgroundBorderSize : backgroundBorderSize
    }
    
    var borderHeightApparentSize: CGFloat {
        instrumentContext.instrumentType == .piano && thisConductor.layoutChoice != .tonic ? borderWidthApparentSize / 2 : borderWidthApparentSize
    }
    var outlineWidth: CGFloat {
        borderWidthApparentSize * outlineSize
    }
    var outlineHeight: CGFloat {
        borderHeightApparentSize * outlineSize
    }
        
    public var body: some View {
        let alignment: Alignment = instrumentContext.instrumentType == .piano && thisConductor.layoutChoice != .tonic ? .top : .center
        GeometryReader { proxy in
            ZStack(alignment: instrumentContext.instrumentType == .piano && thisConductor.layoutChoice != .tonic ? .bottom : .center) {
                
                ZStack(alignment: alignment) {
                    KeyRectangle(fillColor: thisConductor.layoutChoice == .tonic ? Color(UIColor.systemGray6) : .black, pitchView: self, proxySize: proxy.size)
                        .overlay(alignment: alignment) {
                            if outline {
                                KeyRectangle(fillColor: outlineColor, pitchView: self, proxySize: proxy.size)
                                    .frame(width: proxy.size.width - borderWidthApparentSize, height: proxy.size.height - borderHeightApparentSize)
                                    .overlay(alignment: alignment) {
                                        KeyRectangle(fillColor: outlineKeyColor, pitchView: self, proxySize: proxy.size)
                                            .frame(width: proxy.size.width - outlineWidth, height: proxy.size.height - outlineHeight)
                                            .overlay(PitchLabelView(
                                                pitchView: self,
                                                proxySize: proxy.size)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity))
                                    }
                            } else {
                                KeyRectangle(fillColor: keyColor, pitchView: self, proxySize: proxy.size)
                                    .frame(width: proxy.size.width - borderWidthApparentSize, height: proxy.size.height - borderHeightApparentSize)
                                    .overlay(PitchLabelView(pitchView: self, proxySize: proxy.size)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity))
                                    .padding(.leading,  leadingOffset)
                                    .padding(.trailing,  trailingOffset)
                            }
                        }
                }
            }
        }
    }
    
    func darkenSmallKeys(color: Color) -> Color {
        return instrumentContext.instrumentType == .piano && thisConductor.layoutChoice != .tonic ? (isSmall ? color.adjust(brightness: -0.1) : color.adjust(brightness: +0.1)) : color
    }
    
    var accentColor: Color {
        switch thisConductor.paletteChoice {
        case .subtle:
            Color(HomeyPad.secondaryColor)
        case .loud:
            Color(HomeyPad.primaryColor)
        case .ebonyIvory:
            pitch.isNatural ? .black : .white
        }
    }
        
    // Local variable to check activation based on layout
    var isActivated: Bool {
        thisConductor.layoutChoice == .tonic ? pitch.pitchClass.isActivated(in: tonalContext.activatedPitches) : pitch.isActivated
    }

    var keyColor: Color {
        let activeColor: Color
        let inactiveColor: Color

        switch thisConductor.paletteChoice {
        case .subtle:
            activeColor = Color(pitchInterval.majorMinor.color)
            inactiveColor = Color(HomeyPad.primaryColor)
            return isActivated ? activeColor : darkenSmallKeys(color: inactiveColor)
        case .loud:
            activeColor = Color(HomeyPad.primaryColor)
            inactiveColor = Color(pitchInterval.majorMinor.color)
            return isActivated ? activeColor : inactiveColor
        case .ebonyIvory:
            inactiveColor = pitch.isNatural ? .white : Color(UIColor.systemGray4)
            activeColor   = pitch.isNatural ? Color(UIColor.systemGray) : Color(UIColor.systemGray6)
            return isActivated ? activeColor : inactiveColor
        }
    }
    
    var outlineSize: CGFloat {
        if pitchInterval.isTonic {
            return 3.0
        } else {
            return 2.0
        }
    }
    
    var outlineColor: Color {
        switch thisConductor.paletteChoice {
        case .subtle:
            return isActivated ? Color(HomeyPad.primaryColor) : pitchInterval.majorMinor.color
        case .loud:
            return isActivated ? pitchInterval.majorMinor.color : Color(HomeyPad.primaryColor)
        case .ebonyIvory:
            return Color(MajorMinor.altNeutralColor)
        }
    }
    
    var outlineKeyColor: Color {
        switch thisConductor.paletteChoice {
        case .subtle:
            return keyColor
        case .loud:
            return keyColor
        case .ebonyIvory:
            return keyColor
        }
    }
    
    var outline: Bool {
        return thisConductor.outlineChoice &&
        (pitchInterval.isTonic || pitchInterval.isOctave ||
         (modeConductor.showModes && thisConductor.layoutChoice != .tonic && tonalContext.mode.intervalClasses.contains([pitchInterval.intervalClass])))
    }
    
    var isSmall: Bool {
        instrumentContext.instrumentType == .piano && thisConductor.layoutChoice != .tonic && !pitch.isNatural
    }
    
    var backgroundBorderSize: CGFloat {
        isSmall ? 1.0 : 3.0
    }
    
    func minDimension(_ size: CGSize) -> CGFloat {
        return min(size.width, size.height)
    }
    
    // How much of the key height to take up with label
    func relativeFontSize(in containerSize: CGSize) -> CGFloat {
        minDimension(containerSize) * 0.333
    }
    
    func relativeCornerRadius(in containerSize: CGSize) -> CGFloat {
        minDimension(containerSize) * 0.125
    }
    
    func topPadding(_ size: CGSize) -> CGFloat {
        instrumentContext.instrumentType == .piano && thisConductor.layoutChoice != .tonic ? relativeCornerRadius(in: size) : 0.0
    }
    
    func leadingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
    func trailingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
    func negativeTopPadding(_ size: CGSize) -> CGFloat {
        instrumentContext.instrumentType == .piano && thisConductor.layoutChoice != .tonic ? -relativeCornerRadius(in: size) : 0.0
    }
    
    var rotation: CGFloat {
        containerType == .diamond ? 45.0 : 0.0
    }
    
    var leadingOffset: CGFloat {
        0.0
    }
    
    var trailingOffset: CGFloat {
        0.0
    }
}
