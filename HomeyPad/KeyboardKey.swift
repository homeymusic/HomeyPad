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
                text: String = "",
                intervallicKeyColors: [CGColor] = IntervalColor.homeySubtle,
                intervallicKeySymbols: [any Shape] = IntervalSymbol.homey,
                intervallicSymbolColors: [CGColor] = IntervalColor.homey,
                intervallicSymbolSize: [CGFloat] = IntervalSymbolSize.homey,
                backgroundColor: Color = .black,
                subtle: Bool = true,
                isActivatedExternally: Bool = false)
    {
        self.pitch = pitch
        self.isActivated = isActivated
        self.viewpoint = viewpoint
        self.tonicPitch = tonicPitch
        if text == "unset" {
            var newText = ""
            if pitch.note(in: .C).noteClass.description == "C" {
                newText = pitch.note(in: .C).description
            } else {
                newText = ""
            }
            self.text = newText
        } else {
            self.text = text
        }
        self.intervallicKeyColors = intervallicKeyColors
        self.intervallicKeySymbols = intervallicKeySymbols
        self.intervallicSymbolColors = intervallicSymbolColors
        self.intervallicSymbolSize = intervallicSymbolSize
        self.formFactor = formFactor
        self.backgroundColor = backgroundColor
        self.subtle = subtle
        self.isActivatedExternally = isActivatedExternally
    }
    
    var pitch: Pitch
    var isActivated: Bool
    var viewpoint: Viewpoint
    var tonicPitch: Pitch
    var text: String
    var intervallicKeyColors: [CGColor]
    var intervallicKeySymbols: [any Shape]
    var intervallicSymbolColors: [CGColor]
    var intervallicSymbolSize: [CGFloat]
    var formFactor: FormFactor
    var backgroundColor: Color
    var subtle: Bool
    var isActivatedExternally: Bool
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: formFactor == .piano ? .bottom : .center) {
                KeyView(keyboardKey: self, proxySize: proxy.size)
                Text(text)
                    .font(Font(.init(.system, size: relativeFontSize(in: proxy.size))))
                    .foregroundColor(textColor)
                    .padding(relativeFontSize(in: proxy.size) / 3.0)
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
                return Color(intervallicSymbolColors[Int(pitch.intervalClass(to: tonicPitch))])
            } else {
                return isWhite ? .white : .black
            }
        case .intervallic:
            let majorMinorColor = Color(intervallicSymbolColors[Int(pitch.intervalClass(to: tonicPitch))])
            let keyColor = Color(intervallicKeyColors[Int(pitch.intervalClass(to: tonicPitch))])
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
                    return Color(intervallicKeyColors[Int(pitch.intervalClass(to: tonicPitch))])
                }
            } else {
                return Color(intervallicSymbolColors[Int(pitch.intervalClass(to: tonicPitch))])
            }
        } else {
            let color =  Color(intervallicSymbolColors[Int(pitch.intervalClass(to: tonicPitch))])
            if activated {
                return color.adjust(brightness: +0.2)
            } else {
                return color.adjust(brightness: -0.10)
            }
        }
    }
    
    var keySymbol: any Shape {
        return intervallicKeySymbols[pitch == tonicPitch ? 12 : Int(pitch.intervalClass(to: tonicPitch))]
    }
    
    func symbolLength(_ size: CGSize) -> CGFloat {
        return minDimension(size) * intervallicSymbolSize[Int(pitch.intervalClass(to: tonicPitch))]
    }
    
    var isWhite: Bool {
        viewpoint == .diatonic && formFactor == .piano && !isSmall
    }
    
    var isSmall: Bool {
        pitch.note(in: .C).accidental != .natural && formFactor == .piano
    }
    
    var textColor: Color {
        return symbolColor
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
    
    let relativeTextPadding = 0.05
    
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
