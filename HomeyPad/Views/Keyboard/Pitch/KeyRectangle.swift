import SwiftUI

struct KeyRectangle: View {
    var fillColor: Color
    var pitchView: PitchView
    var proxySize: CGSize
    
    var body: some View {
        Rectangle()
            .fill(fillColor)
            .padding(.top, pitchView.topPadding(proxySize))
            .padding(.leading, pitchView.leadingPadding(proxySize))
            .padding(.trailing, pitchView.trailingPadding(proxySize))
            .cornerRadius(pitchView.relativeCornerRadius(in: proxySize))
            .padding(.top, pitchView.negativeTopPadding(proxySize))
            .rotationEffect(.degrees(pitchView.rotation))
    }
}
