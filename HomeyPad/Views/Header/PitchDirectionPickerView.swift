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

    private func pitchDirectionButton(_ pitchDirection: PitchDirection) -> some View {
        let isSelected = (tonality.pitchDirection == pitchDirection)

        return Button(action: {
            guard !isSelected else { return }
            switch (tonality.pitchDirection, pitchDirection) {
            case (.upward, .downward):
                tonality.shiftUpOneOctave()
            case (.downward, .upward):
                tonality.shiftDownOneOctave()
            case (.downward, .mixed):
                tonality.shiftDownOneOctave()
            default:
                break
            }
            tonality.pitchDirection = pitchDirection
            buzz()
        }) {
            Color.clear
                .overlay(Image(systemName: pitchDirection.icon).foregroundColor(.white))
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
