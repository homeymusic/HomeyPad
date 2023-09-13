import Foundation
import SwiftUI
import Keyboard
import Tonic
import Controls
import AVFoundation

struct SwiftUITonicSelector: View {
    var keysPerRow: Int
    var tonicPitchClass: Int
    var noteOn: (Pitch, CGPoint) -> Void = { _, _ in }
    var noteOff: (Pitch)->Void

    var body: some View {
        Keyboard(layout: .dualistic(octaveCount: 1, keysPerRow: keysPerRow, tonicPitchClass: tonicPitchClass),
                 noteOn: noteOn, noteOff: noteOff){ pitch, isActivated in
            SwiftUIKeyboardKey(pitch: pitch,
                               labelType: .text,
                               tonicPitchClass: tonicPitchClass,
                               isActivated: isActivated)
        }.cornerRadius(5)
    }
}

struct SwiftUIKeyboard: View {
    var octaveCount: Int
    var keysPerRow: Int
    var tonicPitchClass: Int
    var noteOn: (Pitch, CGPoint) -> Void = { _, _ in }
    var noteOff: (Pitch)->Void
    
    var body: some View {
        Keyboard(layout: .dualistic(octaveCount: octaveCount, keysPerRow: keysPerRow, tonicPitchClass: tonicPitchClass),
                 noteOn: noteOn, noteOff: noteOff){ pitch, isActivated in
            SwiftUIKeyboardKey(pitch: pitch,
                               labelType: .symbol,
                               tonicPitchClass: tonicPitchClass,
                               isActivated: isActivated)
        }.cornerRadius(5)
    }
}

struct SwiftUIKeyboardKey: View {
    @State var MIDIKeyPressed = [Bool](repeating: false, count: 128)
    var pitch : Pitch
    let labelType: LabelType
    var tonicPitchClass : Int
    var isActivated : Bool
    
    var body: some View {
        VStack{
            IntervallicKey(pitch: pitch,
                           labelType: labelType,
                           tonicPitchClass: tonicPitchClass,
                           isActivated: isActivated,
                           tonicColor: Color(red: 102 / 255, green: 68 / 255, blue: 51 / 255),
                           perfectColor: Color(red: 243 / 255, green: 221 / 255, blue: 171 / 255),
                           majorColor: Color(red: 255 / 255, green: 176 / 255, blue: 0 / 255),
                           minorColor: Color(red: 138 / 255, green: 197 / 255, blue: 320 / 255),
                           tritoneColor: Color(red: 255 / 255, green: 85 / 255, blue: 0 / 255),
                           keyColor: Color(red: 102 / 255, green: 68 / 255, blue: 51 / 255),
                           tonicKeyColor: Color(red: 243 / 255, green: 221 / 255, blue: 171 / 255),
                           flatTop: true,
                           isActivatedExternally: MIDIKeyPressed[pitch.intValue])
        }.onReceive(NotificationCenter.default.publisher(for: .MIDIKey), perform: { obj in
            if let userInfo = obj.userInfo, let info = userInfo["info"] as? UInt8, let val = userInfo["bool"] as? Bool {
                self.MIDIKeyPressed[Int(info)] = val
            }
        })
    }
}
