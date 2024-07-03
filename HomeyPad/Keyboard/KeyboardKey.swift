import SwiftUI

public struct KeyboardKey: View {
    
    @ObservedObject var pitch: Pitch
    @ObservedObject var conductor: ViewConductor
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: conductor.layoutChoice == .piano ? .bottom : .center) {
                KeyView(keyboardKey: self, proxySize: proxy.size)
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
            if tonicTonic {
                Color(conductor.brownColor)
            } else {
                Color(conductor.creamColor)
            }
        case .loud:
            if tonicTonic {
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
            return darkenSmallKeys(color: activated ? activeColor : inactiveColor)
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
    
    var tonicTonic: Bool {
        conductor.layoutChoice == .tonic && pitch.isTonic
    }
    
    var tonicNotTonic: Bool {
        conductor.layoutChoice != .tonic && pitch.isTonic
    }
    
    var outlineSize: CGFloat {
        if tonicNotTonic {
            return 3.0
        } else if tonicTonic {
            return 2.75
        } else {
            return 2.0
        }
    }
    
    var outlineColor: Color {
        switch conductor.paletteChoice {
        case .subtle:
            if tonicTonic {
                return Color(conductor.brownColor)
            } else {
                return activated ? Color(conductor.brownColor) : Color(conductor.creamColor)
            }
        case .loud:
            if tonicTonic {
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
            if tonicTonic {
                return Color(conductor.creamColor)
            } else {
                return keyColor
            }
        case .loud:
            if tonicTonic {
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
    
    func negativeTopPadding(_ size: CGSize) -> CGFloat {
        conductor.layoutChoice == .piano ? -relativeCornerRadius(in: size) : 0.0
    }
    
    func negativeLeadingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
}
