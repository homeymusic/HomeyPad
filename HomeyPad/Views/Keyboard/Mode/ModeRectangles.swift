import SwiftUI
import HomeyMusicKit

/// For accumulating key rects.
struct ModeRectsKey: PreferenceKey {
    static var defaultValue: [ModeRectInfo] = []

    static func reduce(value: inout [ModeRectInfo], nextValue: () -> [ModeRectInfo]) {
        value.append(contentsOf: nextValue())
    }
}

struct ModeRectInfo: Equatable {
    var rect: CGRect
    var mode: Mode
}
