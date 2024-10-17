import HomeyMusicKit
import SwiftUI

public struct KeyboardKeyView: View {
    
    @ObservedObject var pitch: Pitch
    @ObservedObject var conductor: ViewConductor
    @ObservedObject var keyboardViewConductor: ViewConductor
    @StateObject private var tonalContext = TonalContext.shared
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: conductor.layoutChoice == .piano ? .bottom : .center) {
                KeyboardKeySizingView(keyboardKeyView: self, proxySize: proxy.size)
            }
        }
    }
    
    var interval: Interval {
        Interval(pitch: pitch, tonicPitch: tonalContext.tonicPitch)
    }
    
    var activated: Bool {
        if conductor.layoutChoice != .tonic {
            return pitch.midiState == .on
        }
        
        let allActivePitches = keyboardViewConductor.activatedPitches
        
        return allActivePitches.contains { $0.pitchClass == pitch.pitchClass }
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
            pitch.accidental ? .white : .black
        }
    }
    
    var keyColor: Color {
        let activeColor: Color
        let inactiveColor: Color
        
        switch conductor.paletteChoice {
        case .subtle:
            activeColor = Color(interval.majorMinor.color)
            inactiveColor = Color(conductor.mainColor)
            return activated ? activeColor : darkenSmallKeys(color: inactiveColor)
        case .loud:
            activeColor = Color(conductor.mainColor)
            inactiveColor = Color(interval.majorMinor.color)
            return activated ? activeColor : inactiveColor
        case .ebonyIvory:
            inactiveColor = pitch.accidental ? Color(UIColor.systemGray4) : .white
            activeColor =   pitch.accidental ? Color(UIColor.systemGray6) : Color(UIColor.systemGray)
            return activated ? activeColor : inactiveColor
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
        switch conductor.paletteChoice {
        case .subtle:
            return activated ? Color(conductor.brownColor) : Color(conductor.creamColor)
        case .loud:
            return activated ? Color(conductor.creamColor) : Color(conductor.brownColor)
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
        conductor.outlineChoice && interval.isTonicOrOctave
    }
    
    var isSmall: Bool {
        conductor.layoutChoice == .piano && pitch.accidental
    }
    
    var isTritone: Bool {
        self.interval.intervalClass == .six
    }
    
    var isMinor: Bool {
        self.interval.majorMinor == .minor
    }
    
    var isMajor: Bool {
        self.interval.majorMinor == .major
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
        conductor.layoutChoice == .symmetric && isTritone ? 45.0 : 0.0
    }
    
    var leadingOffset: CGFloat {
        0.0
    }
    
    var trailingOffset: CGFloat {
        0.0
    }
}

struct KeyboardKeySizingView: View {
    var keyboardKeyView: KeyboardKeyView
    var proxySize: CGSize
    
    var overlayKey: Bool {
        (keyboardKeyView.conductor.layoutChoice == .symmetric && keyboardKeyView.interval.intervalClass == .six) || keyboardKeyView.isSmall
    }
    
    var body: some View {
        let borderWidthApparentSize = overlayKey ? 2.0 * keyboardKeyView.backgroundBorderSize : keyboardKeyView.backgroundBorderSize
        let borderHeightApparentSize = keyboardKeyView.conductor.layoutChoice == .piano ? borderWidthApparentSize / 2 : borderWidthApparentSize
        let outlineWidth = borderWidthApparentSize * keyboardKeyView.outlineSize
        let outlineHeight = borderHeightApparentSize * keyboardKeyView.outlineSize
        let alignment: Alignment = keyboardKeyView.conductor.layoutChoice == .piano ? .top : .center
        
        ZStack(alignment: alignment) {
            KeyRectangle(fillColor: keyboardKeyView.conductor.layoutChoice == .tonic ? Color(UIColor.systemGray6) : .black, keyboardKeyView: keyboardKeyView, proxySize: proxySize)
                .overlay(alignment: alignment) {
                    if keyboardKeyView.outline {
                        KeyRectangle(fillColor: keyboardKeyView.outlineColor, keyboardKeyView: keyboardKeyView, proxySize: proxySize)
                            .frame(width: proxySize.width - borderWidthApparentSize, height: proxySize.height - borderHeightApparentSize)
                            .overlay(alignment: alignment) {
                                KeyRectangle(fillColor: keyboardKeyView.outlineKeyColor, keyboardKeyView: keyboardKeyView, proxySize: proxySize)
                                    .frame(width: proxySize.width - (keyboardKeyView.outline ? outlineWidth : borderWidthApparentSize), height: proxySize.height - (keyboardKeyView.outline ? outlineHeight : borderHeightApparentSize))
                                    .overlay(KeyboardKeyLabelView(keyboardKeyView: keyboardKeyView, proxySize: proxySize)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity))
                            }
                    } else {
                        KeyRectangle(fillColor: keyboardKeyView.keyColor, keyboardKeyView: keyboardKeyView, proxySize: proxySize)
                            .frame(width: proxySize.width - (keyboardKeyView.outline ? outlineWidth : borderWidthApparentSize), height: proxySize.height - (keyboardKeyView.outline ? outlineHeight : borderHeightApparentSize))
                            .overlay(KeyboardKeyLabelView(keyboardKeyView: keyboardKeyView, proxySize: proxySize)
                                .frame(maxWidth: .infinity, maxHeight: .infinity))
                            .padding(.leading,  keyboardKeyView.leadingOffset)
                            .padding(.trailing,  keyboardKeyView.trailingOffset)
                    }
                }
        }
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
