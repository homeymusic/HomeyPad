import HomeyMusicKit
import SwiftUI

public struct PitchView: View {
    
    @ObservedObject var pitch: Pitch
    @ObservedObject var thisConductor: ViewConductor
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var tonicConductor: ViewConductor
    @ObservedObject var modeConductor: ViewConductor
    
    var interval: Interval {
        Interval.interval(from: tonicConductor.tonalContext.tonicPitch, to: pitch)
    }
    
    // for tritone in symmetric layout and small keys in piano layout
    var overlayKey: Bool {
        return (thisConductor.layoutChoice == .symmetric && interval.isTritone) || isSmall
    }
    
    var borderWidthApparentSize: CGFloat {
        overlayKey ? 2.0 * backgroundBorderSize : backgroundBorderSize
    }
    
    var borderHeightApparentSize: CGFloat {
        thisConductor.layoutChoice == .piano ? borderWidthApparentSize / 2 : borderWidthApparentSize
    }
    var outlineWidth: CGFloat {
        borderWidthApparentSize * outlineSize
    }
    var outlineHeight: CGFloat {
        borderHeightApparentSize * outlineSize
    }
        
    public var body: some View {
        let alignment: Alignment = thisConductor.layoutChoice == .piano ? .top : .center
        GeometryReader { proxy in
            ZStack(alignment: thisConductor.layoutChoice == .piano ? .bottom : .center) {
                
                ZStack(alignment: alignment) {
                    KeyRectangle(fillColor: thisConductor.layoutChoice == .tonic ? Color(UIColor.systemGray6) : .black, pitchView: self, proxySize: proxy.size)
                        .overlay(alignment: alignment) {
                            if outline {
                                KeyRectangle(fillColor: outlineColor, pitchView: self, proxySize: proxy.size)
                                    .frame(width: proxy.size.width - borderWidthApparentSize, height: proxy.size.height - borderHeightApparentSize)
                                    .overlay(alignment: alignment) {
                                        KeyRectangle(fillColor: outlineKeyColor, pitchView: self, proxySize: proxy.size)
                                            .frame(width: proxy.size.width - outlineWidth, height: proxy.size.height - outlineHeight)
                                            .overlay(PitchLabelView(pitchView: self, proxySize: proxy.size)
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
        return thisConductor.layoutChoice == .piano ? isSmall ? color.adjust(brightness: -0.1) : color.adjust(brightness: +0.1) : color
    }
    
    var accentColor: Color {
        switch thisConductor.paletteChoice {
        case .subtle:
            Color(thisConductor.secondaryColor)
        case .loud:
            Color(thisConductor.primaryColor)
        case .ebonyIvory:
            pitch.isNatural ? .black : .white
        }
    }
        
    // Local variable to check activation based on layout
    var isActivated: Bool {
        thisConductor.layoutChoice == .tonic ? pitch.pitchClass.isActivated(in: thisConductor.tonalContext.activatedPitches) : pitch.isActivated
    }

    var keyColor: Color {
        let activeColor: Color
        let inactiveColor: Color

        switch thisConductor.paletteChoice {
        case .subtle:
            activeColor = Color(interval.majorMinor.color)
            inactiveColor = Color(thisConductor.primaryColor)
            return isActivated ? activeColor : darkenSmallKeys(color: inactiveColor)
        case .loud:
            activeColor = Color(thisConductor.primaryColor)
            inactiveColor = Color(interval.majorMinor.color)
            return isActivated ? activeColor : inactiveColor
        case .ebonyIvory:
            inactiveColor = pitch.isNatural ? .white : Color(UIColor.systemGray4)
            activeColor   = pitch.isNatural ? Color(UIColor.systemGray) : Color(UIColor.systemGray6)
            return isActivated ? activeColor : inactiveColor
        }
    }
    
    var outlineSize: CGFloat {
        if interval.isTonic {
            return 3.0
        } else {
            return 2.0
        }
    }
    
    var outlineColor: Color {
        switch thisConductor.paletteChoice {
        case .subtle:
            return isActivated ? Color(thisConductor.primaryColor) : interval.majorMinor.color
        case .loud:
            return isActivated ? interval.majorMinor.color : Color(thisConductor.primaryColor)
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
        (interval.isTonic || interval.isOctave ||
         (modeConductor.showModes && thisConductor.layoutChoice != .tonic && thisConductor.tonalContext.mode.intervalClasses.contains([interval.intervalClass])))
    }
    
    var isSmall: Bool {
        thisConductor.layoutChoice == .piano && !pitch.isNatural
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
        thisConductor.layoutChoice == .piano ? relativeCornerRadius(in: size) : 0.0
    }
    
    func leadingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
    func trailingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
    func negativeTopPadding(_ size: CGSize) -> CGFloat {
        thisConductor.layoutChoice == .piano ? -relativeCornerRadius(in: size) : 0.0
    }
    
    var rotation: CGFloat {
        thisConductor.layoutChoice == .symmetric && interval.isTritone ? 45.0 : 0.0
    }
    
    var leadingOffset: CGFloat {
        0.0
    }
    
    var trailingOffset: CGFloat {
        0.0
    }
}

struct KeyRectangle: View {
    var fillColor: Color
    var pitchView: PitchView
    var proxySize: CGSize
    
    var body: some View {
        Rectangle()
            .fill(fillColor)
            .padding(.top, pitchView.topPadding(proxySize))
            .padding(.leading, pitchView.leadingPadding(proxySize))
            .padding(.trailing, pitchView.trailingPadding(proxySize))
            .cornerRadius(pitchView.relativeCornerRadius(in: proxySize))
            .padding(.top, pitchView.negativeTopPadding(proxySize))
            .rotationEffect(.degrees(pitchView.rotation))
    }
}
