import Keyboard
import SwiftUI
import Tonic

struct ContentView: View {
    @StateObject var viewConductor = ViewConductor()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let keyboards: [Keyboard] = [
            Keyboard(layout: .piano(pitchRange: Pitch(intValue: viewConductor.lowNote) ... Pitch(intValue: viewConductor.highNote)),
                     icon: Image(systemName: "pianokeys"),
                     noteOn: viewConductor.noteOnWithVerticalVelocity(pitch:point:), noteOff: viewConductor.noteOff),
            Keyboard(layout: .isomorphic(pitchRange:
                                            Pitch(intValue: 12 + viewConductor.rootIndex) ... Pitch(intValue: 84 + viewConductor.rootIndex),
                                         root: viewConductor.root,
                                         scale: viewConductor.scale),
                     icon: Image(systemName: "rectangle.split.3x1"),
                     noteOn: viewConductor.noteOnWithReversedVerticalVelocity(pitch:point:),
                     noteOff: viewConductor.noteOff),
            Keyboard(layout: .guitar(),
                     icon: Image(systemName: "guitars"),
                     noteOn: viewConductor.noteOn, noteOff: viewConductor.noteOff) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     text: pitch.note(in: .F).description,
                                     pressedColor: Color(PitchColor.newtonian[Int(pitch.pitchClass)]),
                                     alignment: .center)
                     },
            Keyboard(layout: .isomorphic(pitchRange: Pitch(48) ... Pitch(65)),
                     icon: Image(systemName: "rectangle.split.3x1")) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     text: pitch.note(in: .F).description,
                                     pressedColor: Color(PitchColor.newtonian[Int(pitch.pitchClass)]))
                     }
        ]
        

        HStack {
            VStack {
                HStack {
                    /// select layout
                    Picker("", selection: $viewConductor.keyboardIndex) {
                        ForEach(keyboards.indices) { i in
                            keyboards[i].icon
                                .tag(i)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 75)
                    .padding(.trailing, 10)
                }
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
