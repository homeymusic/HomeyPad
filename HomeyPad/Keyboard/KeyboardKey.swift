// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

public enum Viewpoint {
    case diatonic
    case intervallic
}

public enum FormFactor {
    case isomorphic
    case symmetric
    case piano
    case guitar
}

public struct KeyboardKey: View {
    public init(pitch: Pitch,
                isActivated: Bool,
                viewpoint: Viewpoint = .intervallic,
                formFactor: FormFactor = .symmetric,
                tonicPitch: Pitch = Pitch(60),
                backgroundColor: Color = .black,
                subtle: Bool = true,
                isActivatedExternally: Bool = false)
    {
        self.pitch = pitch
        self.isActivated = isActivated
        self.viewpoint = viewpoint
        self.tonicPitch = tonicPitch
        self.formFactor = formFactor
        self.backgroundColor = backgroundColor
        self.subtle = subtle
        self.isActivatedExternally = isActivatedExternally
        self.interval = Interval(pitch: self.pitch, tonicPitch: self.tonicPitch)
    }
    
    var pitch: Pitch
    var isActivated: Bool
    var viewpoint: Viewpoint
    var tonicPitch: Pitch
    var formFactor: FormFactor
    var backgroundColor: Color
    var subtle: Bool
    var isActivatedExternally: Bool
    var interval: Interval
    var mainColor: CGColor = #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1)
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: formFactor == .piano ? .bottom : .center) {
                KeyView(keyboardKey: self, proxySize: proxy.size)
                LabelView(keyboardKey: self, proxySize: proxy.size)
            }
        }
    }

    var activated: Bool {
        isActivatedExternally || isActivated
    }
    
    var keyColor: Color {
        switch viewpoint {
        case .diatonic:
            if activated {
                return Color(interval.majorMinor.color)
            } else {
                return isWhite ? .white : .black
            }
        case .intervallic:
            let majorMinorColor = Color(interval.majorMinor.color)
            let keyColor = Color(mainColor)
            let pianoColor = isSmall ? keyColor.adjust(brightness: -0.1) : keyColor.adjust(brightness: +0.1)
            if subtle {
                if activated {
                    return majorMinorColor
                } else {
                    if formFactor == .piano {
                        return pianoColor
                    } else {
                        return keyColor
                    }
                }
            } else {
                if activated {
                    if formFactor == .piano {
                        return pianoColor
                    } else {
                        return keyColor
                    }
                } else {
                    return majorMinorColor
                }
            }
        }
    }
    
    var symbolColor: Color {
        if subtle {
            if activated {
                if viewpoint ==  .diatonic {
                    return isWhite ? .white : .black
                } else {
                    return Color(mainColor)
                }
            } else {
                return Color(interval.majorMinor.color)
            }
        } else {
            let color =  Color(interval.majorMinor.color)
            if activated {
                return color.adjust(brightness: +0.2)
            } else {
                return color.adjust(brightness: -0.10)
            }
        }
    }
    
    var keySymbol: any Shape {
        return interval.consonanceDissonance.symbol
    }
    
    func symbolLength(_ size: CGSize) -> CGFloat {
        return minDimension(size) * interval.consonanceDissonance.symbolLength
    }
    
    var isWhite: Bool {
        viewpoint == .diatonic && formFactor == .piano && !isSmall
    }
    
    var isSmall: Bool {
        pitch.accidental && formFactor == .piano
    }
    
    func minDimension(_ size: CGSize) -> CGFloat {
        return min(size.width, size.height)
    }
    
    func isTall(size: CGSize) -> Bool {
        size.height > size.width
    }
    
    // How much of the key height to take up with label
    func relativeFontSize(in containerSize: CGSize) -> CGFloat {
        minDimension(containerSize) * 0.333
    }
    
    func relativeCornerRadius(in containerSize: CGSize) -> CGFloat {
        minDimension(containerSize) * 0.125
    }
    
    func topPadding(_ size: CGSize) -> CGFloat {
        formFactor == .piano ? relativeCornerRadius(in: size) : 0
    }
    
    func leadingPadding(_ size: CGSize) -> CGFloat {
        0
    }
    
    func negativeTopPadding(_ size: CGSize) -> CGFloat {
        formFactor == .piano ? -relativeCornerRadius(in: size) : (isSmall ? 0.5 : 0)
    }
    
    func negativeLeadingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
}
