import Keyboard
import SwiftUI
import Tonic

struct ContentView: View {
    @StateObject var viewConductor = ViewConductor()
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        let keyboards: [Keyboard] = [
            Keyboard(layout: .symmetric(pitchRange: Pitch(intValue: 53) ... Pitch(intValue: 79),
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
                                     centeredTritone: true,
                                     backgroundColor: viewConductor.backgroundColor,
                                     alignment: .center)
                     },
            Keyboard(layout: .piano(pitchRange: Pitch(intValue: 53) ... Pitch(intValue: 79)),
                     icon: Image(systemName: "pianokeys.inverse"),
                     noteOn: viewConductor.noteOnWithVerticalVelocity(pitch:point:), noteOff: viewConductor.noteOff)  { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     viewpoint: .intervallic,
                                     tonicPitch: viewConductor.tonicPitch,
                                     text: "",
                                     intervallicKeyColors: IntervalColor.homey,
                                     intervallicSymbolColors: IntervalColor.homey,
                                     backgroundColor: viewConductor.backgroundColor,
                                     flatTop: true)
                     },
            Keyboard(layout: .piano(pitchRange: Pitch(intValue: 53) ... Pitch(intValue: 79)),
                     icon: Image(systemName: "pianokeys"),
                     noteOn: viewConductor.noteOnWithVerticalVelocity(pitch:point:), noteOff: viewConductor.noteOff)  { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     viewpoint: .diatonic,
                                     tonicPitch: viewConductor.tonicPitch,
                                     text: "",
                                     backgroundColor: viewConductor.backgroundColor,
                                     blackKeyColor: viewConductor.pianoGray,
                                     flatTop: true)
                     },
            Keyboard(layout: .isomorphic(pitchRange: Pitch(intValue: 57) ... Pitch(intValue: 75),
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
                                     intervallicKeyColors: IntervalColor.homey,
                                     intervallicSymbolColors: IntervalColor.homey,
                                     backgroundColor: viewConductor.backgroundColor,
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
                                     intervallicKeyColors: IntervalColor.homey,
                                     intervallicSymbolColors: IntervalColor.homey,
                                     backgroundColor: viewConductor.backgroundColor,
                                     alignment: .center)
                     }
        ]
        
        ZStack {
            viewConductor.backgroundColor
            VStack(spacing: 0) {
                /// Header
                HeaderView(viewConductor: viewConductor)
                /// Keyboard
                keyboards[viewConductor.keyboardIndex]
                    .frame(maxHeight: 300)
                /// Footer
                FooterView(keyboards: keyboards, viewConductor: viewConductor)
            }
        }
        .statusBarHidden(true)
        .ignoresSafeArea(edges:.horizontal)
        .background(viewConductor.backgroundColor)
    }
}
