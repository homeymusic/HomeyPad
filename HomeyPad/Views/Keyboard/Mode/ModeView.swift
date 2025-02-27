import HomeyMusicKit
import SwiftUI

public struct ModeView: View {
    
    let mode: Mode
    @ObservedObject var thisConductor: ViewConductor
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var tonicConductor: ViewConductor
    @ObservedObject var modeConductor: ViewConductor
    @StateObject var tonalContext = TonalContext.shared
    
    var borderWidthApparentSize: CGFloat {
        backgroundBorderSize
    }
    
    var borderHeightApparentSize: CGFloat {
        borderWidthApparentSize
    }
    
    var outlineWidth: CGFloat {
        borderWidthApparentSize * outlineSize
    }
    
    var outlineHeight: CGFloat {
        borderHeightApparentSize * outlineSize
    }
        
    public var body: some View {
        let alignment: Alignment = .center
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                
                ZStack(alignment: alignment) {
                    ModeRectangle(fillColor: Color(UIColor.systemGray6), modeView: self, proxySize: proxy.size)
                        .overlay(alignment: alignment) {
                            if outline {
                                ModeRectangle(fillColor: outlineColor, modeView: self, proxySize: proxy.size)
                                    .frame(width: proxy.size.width - borderWidthApparentSize, height: proxy.size.height - borderHeightApparentSize)
                                    .overlay(alignment: alignment) {
                                        ModeRectangle(fillColor: outlineKeyColor, modeView: self, proxySize: proxy.size)
                                            .frame(width: proxy.size.width - outlineWidth, height: proxy.size.height - outlineHeight)
                                            .overlay(ModeLabelView(modeView: self, proxySize: proxy.size)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity))
                                    }
                            } else {
                                ModeRectangle(fillColor: keyColor, modeView: self, proxySize: proxy.size)
                                    .frame(width: proxy.size.width - borderWidthApparentSize, height: proxy.size.height - borderHeightApparentSize)
                                    .overlay(ModeLabelView(modeView: self, proxySize: proxy.size)
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
        return color
    }
    
    var accentColor: Color {
        switch viewConductor.paletteChoice {
        case .subtle:
            Color(viewConductor.secondaryColor)
        case .loud:
            Color(viewConductor.primaryColor)
        case .ebonyIvory:
            mode.majorMinor == .minor ? .white : .black
        }
    }
        
    // Local variable to check activation based on layout
    var isActivated: Bool {
        false
    }

    var keyColor: Color {
        switch thisConductor.paletteChoice {
        case .subtle:
            return Color(thisConductor.primaryColor)
        case .loud:
            return mode.majorMinor.color
        case .ebonyIvory:
            return mode.majorMinor == .minor ? Color(UIColor.systemGray4) : .white

        }
    }

    var outlineSize: CGFloat {
        if tonalContext.modeOffset == mode {
            return 3.0
        } else {
            return 2.0
        }
    }
    
    var outlineColor: Color {
        switch viewConductor.paletteChoice {
        case .subtle:
            return Color(mode.majorMinor.color)
        case .loud:
            return Color(viewConductor.primaryColor)
        case .ebonyIvory:
            return Color(MajorMinor.altNeutralColor)
        }
    }

    var outlineKeyColor: Color {
        return keyColor
    }
    
    var outline: Bool {
        viewConductor.outlineChoice && (mode == tonalContext.modeOffset)
    }
    
    var isSmall: Bool {
        false
    }
    
    var backgroundBorderSize: CGFloat {
        3.0
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
        0.0
    }
    
    func leadingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
    func trailingPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
    func negativeTopPadding(_ size: CGSize) -> CGFloat {
        0.0
    }
    
    var rotation: CGFloat {
        0.0
    }
    
    var leadingOffset: CGFloat {
        0.0
    }
    
    var trailingOffset: CGFloat {
        0.0
    }
}

struct ModeRectangle: View {
    var fillColor: Color
    var modeView: ModeView
    var proxySize: CGSize
    
    var body: some View {
        Rectangle()
            .fill(fillColor)
            .padding(.top, modeView.topPadding(proxySize))
            .padding(.leading, modeView.leadingPadding(proxySize))
            .padding(.trailing, modeView.trailingPadding(proxySize))
            .cornerRadius(modeView.relativeCornerRadius(in: proxySize))
            .padding(.top, modeView.negativeTopPadding(proxySize))
            .rotationEffect(.degrees(modeView.rotation))
    }
}
