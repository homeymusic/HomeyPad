import SwiftUI

public typealias TouchCallback = ([CGPoint]) -> Void

#if !os(macOS)

import UIKit

class KeyboardKeyMultitouchViewIOS: UIView {
    
    var callback: TouchCallback = { _ in }
    var touches = Set<UITouch>()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touches.formUnion(touches)
        callback(self.touches.map { $0.location(in: nil)})
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        callback(self.touches.map { $0.location(in: nil)})
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touches.subtract(touches)
        callback(self.touches.map { $0.location(in: nil)})
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touches.subtract(touches)
        callback(self.touches.map { $0.location(in: nil)})
    }
}

struct KeyboardKeyMultitouchView: UIViewRepresentable {
    
    var callback: TouchCallback = { _ in }
    
    func makeUIView(context: Context) -> KeyboardKeyMultitouchViewIOS {
        let view = KeyboardKeyMultitouchViewIOS()
        view.callback = callback
        view.isMultipleTouchEnabled = true
        return view
    }
    
    func updateUIView(_ uiView: KeyboardKeyMultitouchViewIOS, context: Context) {
        uiView.callback = callback
    }
}

#endif
