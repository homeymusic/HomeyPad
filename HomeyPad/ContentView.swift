import Keyboard
import SwiftUI
import Tonic

struct ContentView: View {
    @StateObject var viewConductor = ViewConductor()
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        let keyboards: [Keyboard] = [
            Keyboard(layout: .isomorphic(pitchRange: Pitch(intValue: 60) ... Pitch(intValue: 72),
                                         root: viewConductor.root,
                                         scale: viewConductor.scale),
                     icon: Image(systemName: "rectangle.split.2x1"),
                     noteOn: viewConductor.noteOnWithReversedVerticalVelocity(pitch:point:),
                     noteOff: viewConductor.noteOff) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     viewpoint: .intervallic,
                                     tonicPitch: viewConductor.tonicPitch,
                                     text: "",
                                     intervallicKeyColors: IntervalColor.homeySubtle,
                                     intervallicSymbolColors: IntervalColor.homey,
                                     alignment: .center)
                     },
            Keyboard(layout: .symmetric(pitchRange:
                                            Pitch(intValue: 60) ... Pitch(intValue: 72),
                                         root: viewConductor.root,
                                         scale: viewConductor.scale),
                     icon: Image(systemName: "rectangle.split.2x2"),
                     noteOn: viewConductor.noteOnWithReversedVerticalVelocity(pitch:point:),
                     noteOff: viewConductor.noteOff)  { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     viewpoint: .intervallic,
                                     tonicPitch: viewConductor.tonicPitch,
                                     text: "",
                                     intervallicKeyColors: IntervalColor.homey,
                                     intervallicSymbolColors: IntervalColor.homey,
                                     alignment: .center)
                     },
            Keyboard(layout: .piano(pitchRange: Pitch(intValue: 60) ... Pitch(intValue: 72)),
                     icon: Image(systemName: "pianokeys"),
                     noteOn: viewConductor.noteOnWithVerticalVelocity(pitch:point:), noteOff: viewConductor.noteOff)  { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     viewpoint: .intervallic,
                                     tonicPitch: viewConductor.tonicPitch,
                                     text: "",
                                     intervallicKeyColors: IntervalColor.homey,
                                     intervallicSymbolColors: IntervalColor.homey,
                                     alignment: .center)
                     },
            Keyboard(layout: .guitar(),
                     icon: Image(systemName: "guitars"),
                     noteOn: viewConductor.noteOn, noteOff: viewConductor.noteOff) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     viewpoint: .intervallic,
                                     tonicPitch: viewConductor.tonicPitch,
                                     text: "",
                                     intervallicKeyColors: IntervalColor.homeySubtle,
                                     intervallicSymbolColors: IntervalColor.homey,
                                     alignment: .center)
                     }
        ]
        
        
        HStack {
            VStack {
                KeyboardLayoutPickerView(keyboards: keyboards, viewConductor: viewConductor)
                VStack {
                    Spacer()
                    keyboards[viewConductor.keyboardIndex]
                        .frame(maxHeight: 300)
                    Spacer()
                }
                .background(Color.black)
            }
        }
        .ignoresSafeArea(edges:.horizontal)
        .background(Color.gray)
    }
}
