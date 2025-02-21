import HomeyMusicKit
import SwiftUI

public struct KeyboardKeyView: View {
    
    @ObservedObject var pitch: Pitch
    @ObservedObject var conductor: ViewConductor
    @ObservedObject var keyboardViewConductor: ViewConductor
    @StateObject var tonalContext = TonalContext.shared
    
    // for tritone in symmetric layout and small keys in piano layout
    var overlayKey: Bool {
        return (conductor.layoutChoice == .symmetric && pitch.interval(from: tonalContext.tonicPitch).isTritone) || isSmall
    }
    
    var borderWidthApparentSize: CGFloat {
        overlayKey ? 2.0 * backgroundBorderSize : backgroundBorderSize
    }
    
    var borderHeightApparentSize: CGFloat {
        conductor.layoutChoice == .piano ? borderWidthApparentSize / 2 : borderWidthApparentSize
    }
    var outlineWidth: CGFloat {
        borderWidthApparentSize * outlineSize
    }
    var outlineHeight: CGFloat {
        borderHeightApparentSize * outlineSize
    }
        
    public var body: some View {
        let alignment: Alignment = conductor.layoutChoice == .piano ? .top : .center
        GeometryReader { proxy in
            ZStack(alignment: conductor.layoutChoice == .piano ? .bottom : .center) {
                
                ZStack(alignment: alignment) {
                    KeyRectangle(fillColor: conductor.layoutChoice == .tonic ? Color(UIColor.systemGray6) : .black, keyboardKeyView: self, proxySize: proxy.size)
                        .overlay(alignment: alignment) {
                            if outline {
                                KeyRectangle(fillColor: outlineColor, keyboardKeyView: self, proxySize: proxy.size)
                                    .frame(width: proxy.size.width - borderWidthApparentSize, height: proxy.size.height - borderHeightApparentSize)
                                    .overlay(alignment: alignment) {
                                        KeyRectangle(fillColor: outlineKeyColor, keyboardKeyView: self, proxySize: proxy.size)
                                            .frame(width: proxy.size.width - outlineWidth, height: proxy.size.height - outlineHeight)
                                            .overlay(KeyboardKeyLabelView(keyboardKeyView: self, proxySize: proxy.size)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity))
                                    }
                            } else {
                                KeyRectangle(fillColor: keyColor, keyboardKeyView: self, proxySize: proxy.size)
                                    .frame(width: proxy.size.width - borderWidthApparentSize, height: proxy.size.height - borderHeightApparentSize)
                                    .overlay(KeyboardKeyLabelView(keyboardKeyView: self, proxySize: proxy.size)
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
        return conductor.layoutChoice == .piano ? isSmall ? color.adjust(brightness: -0.1) : color.adjust(brightness: +0.1) : color
    }
    
    var accentColor: Color {
        switch conductor.paletteChoice {
        case .subtle:
            Color(conductor.creamColor)
        case .loud:
            Color(conductor.brownColor)
        case .ebonyIvory:
            pitch.isNatural ? .black : .white
        }
    }
        
    // Local variable to check activation based on layout
    var isActivated: Bool {
        conductor.layoutChoice == .tonic ? pitch.pitchClass.isActivated : pitch.isActivated.value
    }

    var keyColor: Color {
        let activeColor: Color
        let inactiveColor: Color

        switch conductor.paletteChoice {
        case .subtle:
            activeColor = Color(pitch.interval(from: tonalContext.tonicPitch).majorMinor.color)
            inactiveColor = Color(conductor.mainColor)
            return isActivated ? activeColor : darkenSmallKeys(color: inactiveColor)
        case .loud:
            activeColor = Color(conductor.mainColor)
            inactiveColor = Color(pitch.interval(from: tonalContext.tonicPitch).majorMinor.color)
            return isActivated ? activeColor : inactiveColor
        case .ebonyIvory:
            inactiveColor = pitch.isNatural ? .white : Color(UIColor.systemGray4)
            activeColor   = pitch.isNatural ? Color(UIColor.systemGray) : Color(UIColor.systemGray6)
            return isActivated ? activeColor : inactiveColor
        }
    }
    
    var outlineSize: CGFloat {
        if pitch.interval(from: tonalContext.tonicPitch).isTonic {
            return 3.0
        } else {
            return 2.0
        }
    }
    
    var outlineColor: Color {
        switch conductor.paletteChoice {
        case .subtle:
            return isActivated ? Color(conductor.brownColor) : Color(conductor.creamColor)
        case .loud:
            return isActivated ? Color(conductor.creamColor) : Color(conductor.brownColor)
        case .ebonyIvory:
            return Color(MajorMinor.altNeutralColor)
        }
    }
    
    var outlineKeyColor: Color {
        switch conductor.paletteChoice {
        case .subtle:
            return keyColor
        case .loud:
            return keyColor
        case .ebonyIvory:
            return keyColor
        }
    }
    
    var outline: Bool {
        conductor.outlineChoice && (pitch.interval(from: tonalContext.tonicPitch).isTonic || pitch.interval(from: tonalContext.tonicPitch).isOctave)
    }
    
    var isSmall: Bool {
        conductor.layoutChoice == .piano && !pitch.isNatural
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
        conductor.layoutChoice == .piano ? relativeCornerRadius(in: size) : 0.0
    }
    
    func leadingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
    func trailingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
    func negativeTopPadding(_ size: CGSize) -> CGFloat {
        conductor.layoutChoice == .piano ? -relativeCornerRadius(in: size) : 0.0
    }
    
    var rotation: CGFloat {
        conductor.layoutChoice == .symmetric && pitch.interval(from: tonalContext.tonicPitch).isTritone ? 45.0 : 0.0
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
    var keyboardKeyView: KeyboardKeyView
    var proxySize: CGSize
    
    var body: some View {
        Rectangle()
            .fill(fillColor)
            .padding(.top, keyboardKeyView.topPadding(proxySize))
            .padding(.leading, keyboardKeyView.leadingPadding(proxySize))
            .padding(.trailing, keyboardKeyView.trailingPadding(proxySize))
            .cornerRadius(keyboardKeyView.relativeCornerRadius(in: proxySize))
            .padding(.top, keyboardKeyView.negativeTopPadding(proxySize))
            .rotationEffect(.degrees(keyboardKeyView.rotation))
    }
}
