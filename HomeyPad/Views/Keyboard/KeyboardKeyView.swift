import HomeyMusicKit
import SwiftUI

public struct KeyboardKeyView: View {
    
    @ObservedObject var pitch: Pitch
    @ObservedObject var conductor: ViewConductor
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: conductor.layoutChoice == .piano ? .bottom : .center) {
                KeyboardKeySizingView(keyboardKey: self, proxySize: proxy.size)
            }
        }
    }
    
    var interval: Interval {
        Interval(pitch: pitch, tonicPitch: conductor.tonicPitch)
    }
    
    var activated: Bool {
        pitch.midiState == .on
    }
    
    func darkenSmallKeys(color: Color) -> Color {
        return conductor.layoutChoice == .piano ? isSmall ? color.adjust(brightness: -0.1) : color.adjust(brightness: +0.1) : color
    }
    
    var accentColor: Color {
        switch conductor.paletteChoice {
        case .subtle:
            if isTonicTonic {
                Color(conductor.brownColor)
            } else {
                Color(conductor.creamColor)
            }
        case .loud:
            if isTonicTonic {
                Color(conductor.creamColor)
            } else {
                Color(conductor.brownColor)
            }
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
    
    var isTonicTonic: Bool {
        conductor.layoutChoice == .tonic && pitch.isTonic
    }
    
    var tonicNotTonic: Bool {
        conductor.layoutChoice != .tonic && pitch.isTonic
    }
    
    var outlineSize: CGFloat {
        if tonicNotTonic {
            return 3.0
        } else if isTonicTonic {
            return 2.75
        } else {
            return 2.0
        }
    }
    
    var outlineColor: Color {
        switch conductor.paletteChoice {
        case .subtle:
            if isTonicTonic {
                return Color(conductor.brownColor)
            } else {
                return activated ? Color(conductor.brownColor) : Color(conductor.creamColor)
            }
        case .loud:
            if isTonicTonic {
                return Color(conductor.creamColor)
            } else {
                return activated ? Color(conductor.creamColor) : Color(conductor.brownColor)
            }
        case .ebonyIvory:
            return Color(MajorMinor.altNeutralColor)
        }
    }
    
    var outlineKeyColor: Color {
        switch conductor.paletteChoice {
        case .subtle:
            if isTonicTonic {
                return Color(conductor.creamColor)
            } else {
                return keyColor
            }
        case .loud:
            if isTonicTonic {
                return Color(conductor.brownColor)
            } else {
                return keyColor
            }
        case .ebonyIvory:
            return keyColor
        }
    }
    
    var outline: Bool {
        conductor.outlineChoice &&
        (pitch.midi == conductor.tonicMIDI || pitch.midi == conductor.octaveMIDI)
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
    
    var isTonicOrOctave: Bool {
        self.interval.intervalClass == .zero 
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
    var keyboardKey: KeyboardKeyView
    var proxySize: CGSize
    
    var overlayKey: Bool {
        (keyboardKey.conductor.layoutChoice == .symmetric && keyboardKey.interval.intervalClass == .six) || keyboardKey.isSmall
    }
    
    var body: some View {
        let borderWidthApparentSize = overlayKey ? 2.0 * keyboardKey.backgroundBorderSize : keyboardKey.backgroundBorderSize
        let borderHeightApparentSize = keyboardKey.conductor.layoutChoice == .piano ? borderWidthApparentSize / 2 : borderWidthApparentSize
        let outlineWidth = borderWidthApparentSize * keyboardKey.outlineSize
        let outlineHeight = borderHeightApparentSize * keyboardKey.outlineSize
        let alignment: Alignment = keyboardKey.conductor.layoutChoice == .piano ? .top : .center
        
        ZStack(alignment: alignment) {
            KeyRectangle(fillColor: keyboardKey.conductor.backgroundColor, keyboardKey: keyboardKey, proxySize: proxySize)
                .overlay(alignment: alignment) {
                    if keyboardKey.outline {
                        KeyRectangle(fillColor: keyboardKey.outlineColor, keyboardKey: keyboardKey, proxySize: proxySize)
                            .frame(width: proxySize.width - borderWidthApparentSize, height: proxySize.height - borderHeightApparentSize)
                            .overlay(alignment: alignment) {
                                KeyRectangle(fillColor: keyboardKey.outlineKeyColor, keyboardKey: keyboardKey, proxySize: proxySize)
                                    .frame(width: proxySize.width - (keyboardKey.outline ? outlineWidth : borderWidthApparentSize), height: proxySize.height - (keyboardKey.outline ? outlineHeight : borderHeightApparentSize))
                                    .overlay(KeyboardKeyLabelView(keyboardKey: keyboardKey, proxySize: proxySize)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity))
                            }
                    } else {
                        KeyRectangle(fillColor: keyboardKey.keyColor, keyboardKey: keyboardKey, proxySize: proxySize)
                            .frame(width: proxySize.width - (keyboardKey.outline ? outlineWidth : borderWidthApparentSize), height: proxySize.height - (keyboardKey.outline ? outlineHeight : borderHeightApparentSize))
                            .overlay(KeyboardKeyLabelView(keyboardKey: keyboardKey, proxySize: proxySize)
                                .frame(maxWidth: .infinity, maxHeight: .infinity))
                            .padding(.leading,  keyboardKey.leadingOffset)
                            .padding(.trailing,  keyboardKey.trailingOffset)
                    }
                }
        }
    }
}

struct KeyRectangle: View {
    var fillColor: Color
    var keyboardKey: KeyboardKeyView
    var proxySize: CGSize
    
    var body: some View {
        Rectangle()
            .fill(fillColor)
            .padding(.top, keyboardKey.topPadding(proxySize))
            .padding(.leading, keyboardKey.leadingPadding(proxySize))
            .padding(.trailing, keyboardKey.trailingPadding(proxySize))
            .cornerRadius(keyboardKey.relativeCornerRadius(in: proxySize))
            .padding(.top, keyboardKey.negativeTopPadding(proxySize))
            .rotationEffect(.degrees(keyboardKey.rotation))
    }
}
