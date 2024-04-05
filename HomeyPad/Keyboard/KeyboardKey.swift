// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

public enum Viewpoint {
    case diatonic
    case intervallic
}

public struct KeyboardKey: View {

    var pitch: Pitch
    var tonicPitch: Pitch
    var layoutChoice: LayoutChoice
    var paletteChoice: PaletteChoice
    var backgroundColor: Color
    var intervalLabels: [LayoutChoice: [IntervalLabelChoice: Bool]]
    var interval: Interval
    var brownColor: CGColor = #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1)
    var creamColor: CGColor = #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1)

    public init(pitch: Pitch,
                tonicPitch: Pitch,
                layoutChoice: LayoutChoice = .symmetric,
                paletteChoice: PaletteChoice = .subtle,
                backgroundColor: Color = .black,
                intervalLabels: [LayoutChoice: [IntervalLabelChoice: Bool]] = [:])
    {
        self.pitch = pitch
        self.tonicPitch = tonicPitch
        self.layoutChoice = layoutChoice
        self.paletteChoice = paletteChoice
        self.backgroundColor = backgroundColor
        self.intervalLabels = intervalLabels
        self.interval = Interval(pitch: self.pitch, tonicPitch: self.tonicPitch)
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: layoutChoice == .piano ? .bottom : .center) {
                KeyView(keyboardKey: self, proxySize: proxy.size)
                LabelView(keyboardKey: self, proxySize: proxy.size)
            }
        }
    }

    var mainColor: Color {
        return Color(brownColor)
    }
    var accentColor: Color {
        switch paletteChoice {
        case .subtle:
            Color(creamColor)
        case .loud:
            Color(brownColor)
        case .ebonyIvory:
            Color(brownColor)
        }
    }

    var activated: Bool {
        pitch.midiState == .on
    }
    
    func darkenSmallKeys(color: Color) -> Color {
        return layoutChoice == .piano ? isSmall ? color.adjust(brightness: -0.1) : color.adjust(brightness: +0.1) : color
    }
    
    var keyColor: Color {
        let activeColor: Color
        let inactiveColor: Color

        switch paletteChoice {
        case .subtle:
            activeColor = Color(interval.majorMinor.color)
            inactiveColor = Color(mainColor)
            return darkenSmallKeys(color: activated ? activeColor : inactiveColor)
        case .loud:
            activeColor = Color(mainColor)
            inactiveColor = Color(interval.majorMinor.color)
            return activated ? activeColor : inactiveColor
        case .ebonyIvory:
            inactiveColor = pitch.accidental ? Color(.darkGray) : Color(.white)
            activeColor = inactiveColor.adjust(brightness: -0.2)
            return activated ? activeColor : inactiveColor
        }
    }
    
    var symbolColor: Color {
        let activeColor: Color
        let inactiveColor: Color

        switch paletteChoice {
        case .subtle:
            activeColor = Color(mainColor)
            inactiveColor = Color(interval.majorMinor.color)
        case .loud:
            activeColor = Color(interval.majorMinor.color)
            inactiveColor = Color(mainColor)
        case .ebonyIvory:
            inactiveColor = Color(pitch.accidental ? interval.majorMinor.color : interval.majorMinor.colorOnWhite)
            activeColor = inactiveColor
        }
        return activated ? activeColor : inactiveColor
    }
    
    var keySymbol: any Shape {
        return interval.consonanceDissonance.symbol
    }
    
    func symbolLength(_ size: CGSize) -> CGFloat {
        return minDimension(size) * interval.consonanceDissonance.symbolLength
    }
    
    var isSmall: Bool {
        layoutChoice == .piano && pitch.accidental
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
        layoutChoice == .piano ? relativeCornerRadius(in: size) : 0.0
    }
    
    func leadingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
    func negativeTopPadding(_ size: CGSize) -> CGFloat {
        layoutChoice == .piano ? -relativeCornerRadius(in: size) : (isSmall ? 0.5 : 0.0)
    }
    
    func negativeLeadingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
}
