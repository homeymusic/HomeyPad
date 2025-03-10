import HomeyMusicKit
import SwiftUI

public enum ContainerType {
    case basic
    case diamond
    case span
    case tonicPicker
}

public struct PitchView: View {
    
    @ObservedObject var pitch: Pitch
    let containerType: ContainerType

    @EnvironmentObject var tonalContext: TonalContext
    @EnvironmentObject var instrumentalContext: InstrumentalContext
    @EnvironmentObject var notationalContext: NotationalContext
    @EnvironmentObject var notationalTonicContext: NotationalTonicContext

    var pitchInterval: Interval {
        return tonalContext.interval(fromTonicTo: pitch)
    }
    
    var borderWidthApparentSize: CGFloat {
        isSmall ? 2.0 * backgroundBorderSize : backgroundBorderSize
    }
    
    var borderHeightApparentSize: CGFloat {
        instrumentalContext.instrumentType == .piano && containerType != .tonicPicker ? borderWidthApparentSize / 2 : borderWidthApparentSize
    }
    var outlineWidth: CGFloat {
        borderWidthApparentSize * outlineSize
    }
    var outlineHeight: CGFloat {
        borderHeightApparentSize * outlineSize
    }
        
    public var body: some View {
        let alignment: Alignment = instrumentalContext.instrumentType == .piano && containerType != .tonicPicker ? .top : .center
        GeometryReader { proxy in
            ZStack(alignment: instrumentalContext.instrumentType == .piano && containerType != .tonicPicker ? .bottom : .center) {
                
                ZStack(alignment: alignment) {
                    KeyRectangle(fillColor: containerType != .tonicPicker ? Color(UIColor.systemGray6) : .black, pitchView: self, proxySize: proxy.size)
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
        return instrumentalContext.instrumentType == .piano && containerType != .tonicPicker ? (isSmall ? color.adjust(brightness: -0.1) : color.adjust(brightness: +0.1)) : color
    }
    
    var accentColor: Color {
        switch notationalContext.colorPalette[instrumentalContext.instrumentType]! {
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
        containerType == .tonicPicker ? pitch.pitchClass.isActivated(in: tonalContext.activatedPitches) : pitch.isActivated
    }

    var keyColor: Color {
        let activeColor: Color
        let inactiveColor: Color

        switch notationalContext.colorPalette[instrumentalContext.instrumentType]! {
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
        switch notationalContext.colorPalette[instrumentalContext.instrumentType]! {
        case .subtle:
            return isActivated ? Color(HomeyPad.primaryColor) : pitchInterval.majorMinor.color
        case .loud:
            return isActivated ? pitchInterval.majorMinor.color : Color(HomeyPad.primaryColor)
        case .ebonyIvory:
            return Color(MajorMinor.altNeutralColor)
        }
    }
    
    var outlineKeyColor: Color {
        keyColor
    }
    
    var outline: Bool {
        return notationalContext.outline[instrumentalContext.instrumentType]! &&
        (pitchInterval.isTonic || pitchInterval.isOctave ||
         (notationalTonicContext.showModes && containerType != .tonicPicker && tonalContext.mode.intervalClasses.contains([pitchInterval.intervalClass])))
    }
    
    var isSmall: Bool {
        instrumentalContext.instrumentType == .piano && containerType != .tonicPicker && !pitch.isNatural
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
        instrumentalContext.instrumentType == .piano && containerType != .tonicPicker ? relativeCornerRadius(in: size) : 0.0
    }
    
    func leadingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
    func trailingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
    func negativeTopPadding(_ size: CGSize) -> CGFloat {
        instrumentalContext.instrumentType == .piano && containerType != .tonicPicker ? -relativeCornerRadius(in: size) : 0.0
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
