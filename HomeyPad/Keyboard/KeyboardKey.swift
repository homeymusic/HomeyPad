// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

public enum Viewpoint {
    case diatonic
    case intervallic
}

public struct KeyboardKey: View {

    @StateObject var pitch: Pitch
    @StateObject var viewConductor: ViewConductor
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: viewConductor.layoutChoice == .piano ? .bottom : .center) {
                KeyView(keyboardKey: self, proxySize: proxy.size)
            }
        }
    }
    
    var interval: Interval {
        Interval(pitch: pitch, tonicPitch: viewConductor.tonicPitch)
    }

    var activated: Bool {
        print("key pitch.midiState \(pitch.midiState)")

        return pitch.midiState == .on
    }
    
    func darkenSmallKeys(color: Color) -> Color {
        return viewConductor.layoutChoice == .piano ? isSmall ? color.adjust(brightness: -0.1) : color.adjust(brightness: +0.1) : color
    }
    
    var keyColor: Color {
        let activeColor: Color
        let inactiveColor: Color

        switch viewConductor.paletteChoice {
        case .subtle:
            activeColor = Color(interval.majorMinor.color)
            inactiveColor = Color(viewConductor.mainColor)
            return darkenSmallKeys(color: activated ? activeColor : inactiveColor)
        case .loud:
            activeColor = Color(viewConductor.mainColor)
            inactiveColor = Color(interval.majorMinor.color)
            return activated ? activeColor : inactiveColor
        case .ebonyIvory:
            inactiveColor = pitch.accidental ? Color(.darkGray) : Color(.white)
            activeColor = inactiveColor.adjust(brightness: -0.2)
            return activated ? activeColor : inactiveColor
        }
    }
    
    var outlineTonic: Bool {
        viewConductor.paletteChoice == .subtle && interval.intervalClass == .zero
    }

    var isSmall: Bool {
        viewConductor.layoutChoice == .piano && pitch.accidental
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
        viewConductor.layoutChoice == .piano ? relativeCornerRadius(in: size) : 0.0
    }
    
    func leadingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
    func negativeTopPadding(_ size: CGSize) -> CGFloat {
        viewConductor.layoutChoice == .piano ? -relativeCornerRadius(in: size) : (isSmall ? 0.5 : 0.0)
    }
    
    func negativeLeadingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
}
