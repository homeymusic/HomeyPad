import SwiftUI
import HomeyMusicKit

public struct ModeLabelView: View {
    var modeView: ModeView
    var proxySize: CGSize
    
    public var body: some View {
        let topBottomPadding = modeView.outline ? 0.0 : 0.5 * modeView.outlineSize
        let extraPadding = topBottomPadding
        VStack(spacing: 0.0) {
            Labels(modeView: modeView, proxySize: proxySize)
                .padding([.top, .bottom], extraPadding)
        }
    }
    
    struct Labels: View {
        let modeView: ModeView
        let proxySize: CGSize
        var rotation: Angle = .degrees(0)

        var body: some View {
            VStack(spacing: 2) {
                VStack(spacing: 1) {
                    guideModeLabel
                }
            }
            .padding(2.0)
            .foregroundColor(textColor)
            .minimumScaleFactor(0.1)
            .lineLimit(1)
        }
        
        var guideModeLabel: some View {
            AnyView(
                HStack(spacing: 0.0) {
                    if modeView.modeConductor.noteLabel[.mode]! {
                        Color.clear.overlay(
                            HStack(spacing: 1.0) {
                                Text(modeView.mode.shortHand)
                                    .foregroundColor(Color(textColor))
                            }
                                .padding(2.0)
                                .background(Color(modeView.keyColor))
                                .cornerRadius(3.0)
                        )
                    }
                    if modeView.modeConductor.noteLabel[.guide]! {
                        Color.clear.overlay(
                            HStack(spacing: 1.0) {
                                guideIconImages
                            }
                                .aspectRatio(modeView.mode.scale == .pentatonic ? 3.0 : 2.0, contentMode: .fit)
                                .padding(2.0)
                                .background(modeView.viewConductor.paletteChoice == .loud ? Color(HomeyPad.primaryColor) : modeView.keyColor)
                                .cornerRadius(3.0)
                        )
                    }
                }
            )
        }
        
        var guideIconImages: some View {
            Group {
                Image(systemName: "square")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.clear)
                    .overlay(
                        Image(systemName: modeView.mode.pitchDirection.icon)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(modeView.viewConductor.paletteChoice == .ebonyIvory ? modeView.accentColor :  modeView.mode.pitchDirection.majorMinor.color))
                    )
                Image(systemName: "square")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.clear)
                    .overlay(
                        Image(systemName: modeView.mode.chordShape.icon)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(modeView.viewConductor.paletteChoice == .ebonyIvory ? modeView.accentColor : modeView.mode.chordShape.majorMinor.color))
                    )
                if modeView.mode.scale == .pentatonic {
                    Image(systemName: "square")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.clear)
                        .overlay(
                            Image(systemName: Scale.pentatonic.icon)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(modeView.viewConductor.paletteChoice == .ebonyIvory ? modeView.accentColor : modeView.mode.majorMinor.color))
                        )
                }
            }
        }
        
        func minDimension(_ size: CGSize) -> CGFloat {
            return min(size.width, size.height)
        }
        
        var textColor: Color {
            switch modeView.viewConductor.paletteChoice {
            case .subtle:
                return modeView.mode.majorMinor.color
            case .loud:
                return Color(HomeyPad.primaryColor)
            case .ebonyIvory:
                return modeView.mode.majorMinor == .minor ? .white : .black
            }
        }

    }
}

