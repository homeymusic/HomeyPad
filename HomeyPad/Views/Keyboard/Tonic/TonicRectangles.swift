import SwiftUI
import HomeyMusicKit

struct TonicRectsKey: PreferenceKey {
    static var defaultValue: [TonicRectInfo] = []

    static func reduce(value: inout [TonicRectInfo], nextValue: () -> [TonicRectInfo]) {
        value.append(contentsOf: nextValue())
    }
}

struct TonicRectInfo: Equatable {
    var rect: CGRect
    var pitch: Pitch
    var zIndex: Int = 0
}
