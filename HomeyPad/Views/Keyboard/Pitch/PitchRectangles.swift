import SwiftUI
import HomeyMusicKit

/// For accumulating key rects.
struct PitchRectsKey: PreferenceKey {
    static var defaultValue: [PitchRectInfo] = []

    static func reduce(value: inout [PitchRectInfo], nextValue: () -> [PitchRectInfo]) {
        value.append(contentsOf: nextValue())
    }
}

struct PitchRectInfo: Equatable {
    var rect: CGRect
    var pitch: Pitch
    var zIndex: Int = 0
}
