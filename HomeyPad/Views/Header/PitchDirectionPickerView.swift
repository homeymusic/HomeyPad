import SwiftUI
import HomeyMusicKit

struct PitchDirectionPickerView: View {
    @StateObject private var tonalContext = TonalContext.shared

    var body: some View {
        HStack {
            Picker("", selection: $tonalContext.pitchDirection) {
                Image(systemName: PitchDirection.downward.icon)
                    .tag(PitchDirection.downward)
                Image(systemName: PitchDirection.upward.icon)
                    .tag(PitchDirection.upward)
            }
            .frame(maxWidth: 90)
            .pickerStyle(.segmented)
        }
    }
}
