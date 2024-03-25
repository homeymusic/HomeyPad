import Keyboard
import SwiftUI
import Tonic

struct ContentView: View {
    @StateObject var viewConductor = ViewConductor()
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        let keyboards: [Keyboard] = [
            Keyboard(layout: .isomorphic(pitchRange:
                                            Pitch(intValue: 12 + viewConductor.rootIndex) ... Pitch(intValue: 84 + viewConductor.rootIndex),
                                         root: viewConductor.root,
                                         scale: viewConductor.scale),
                     icon: Image(systemName: "rectangle.split.2x1"),
                     noteOn: viewConductor.noteOnWithReversedVerticalVelocity(pitch:point:),
                     noteOff: viewConductor.noteOff) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     viewpoint: .intervallic,
                                     tonicPitch: viewConductor.tonicPitch,
                                     text: pitch.note(in: .F).description,
                                     intervallicKeyColors: PitchColor.homey,
                                     alignment: .center)
                     },
            Keyboard(layout: .isomorphic(pitchRange:
                                            Pitch(intValue: 12 + viewConductor.rootIndex) ... Pitch(intValue: 84 + viewConductor.rootIndex),
                                         root: viewConductor.root,
                                         scale: viewConductor.scale),
                     icon: Image(systemName: "rectangle.split.2x2"),
                     noteOn: viewConductor.noteOnWithReversedVerticalVelocity(pitch:point:),
                     noteOff: viewConductor.noteOff)  { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     viewpoint: .intervallic,
                                     tonicPitch: viewConductor.tonicPitch,
                                     text: pitch.note(in: .F).description,
                                     intervallicKeyColors: PitchColor.homey,
                                     alignment: .center)
                     },
            Keyboard(layout: .piano(pitchRange: Pitch(intValue: viewConductor.lowNote) ... Pitch(intValue: viewConductor.highNote)),
                     icon: Image(systemName: "pianokeys"),
                     noteOn: viewConductor.noteOnWithVerticalVelocity(pitch:point:), noteOff: viewConductor.noteOff)  { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     viewpoint: .intervallic,
                                     tonicPitch: viewConductor.tonicPitch,
                                     text: pitch.note(in: .F).description,
                                     intervallicKeyColors: PitchColor.homey,
                                     alignment: .center)
                     },
            Keyboard(layout: .guitar(),
                     icon: Image(systemName: "guitars"),
                     noteOn: viewConductor.noteOn, noteOff: viewConductor.noteOff) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     viewpoint: .intervallic,
                                     tonicPitch: viewConductor.tonicPitch,
                                     text: pitch.note(in: .F).description,
                                     intervallicKeyColors: PitchColor.homey,
                                     alignment: .center)
                     }
        ]
        
        
        HStack {
            VStack {
                KeyboardLayoutPickerView(keyboards: keyboards, viewConductor: viewConductor)
                NoteRangeStepperView(viewConductor: viewConductor)
                HStack {
                    RootStepperView(viewConductor: viewConductor)
                    ScaleStepperView(viewConductor: viewConductor)
                }
                Spacer()
                keyboards[viewConductor.keyboardIndex]
                    .frame(maxHeight: 300)
                Spacer()
            }
        }
        .ignoresSafeArea(edges:.horizontal)
        .background(Color.gray)
    }
}
