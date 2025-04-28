import SwiftUI
import HomeyMusicKit

public struct PitchDirectionPickerView: View {
    @Bindable var tonality: Tonality

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(PitchDirection.allCases, id: \.self) { direction in
                pitchDirectionButton(direction)

                if direction != .upward {
                    divider
                }
            }
        }
        .background(Color.systemGray6)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func pitchDirectionButton(_ direction: PitchDirection) -> some View {
        let isSelected = (tonality.pitchDirection == direction)

        return Button(action: {
            guard !isSelected else { return }
            tonality.pitchDirection = direction
        }) {
            Color.clear
                .overlay(Image(systemName: direction.icon).foregroundColor(.white))
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 44)
                .background(isSelected ? Color.systemGray2 : Color.clear)
        }
        .disabled(isSelected)
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.systemGray4)
            .frame(width: 1, height: 17.5)
    }
}
