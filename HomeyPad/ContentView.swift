import Keyboard
import SwiftUI
import Tonic

struct ContentView: View {
    @StateObject var viewConductor = ViewConductor()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let keyboards: [Keyboard] = [
            Keyboard(layout: .piano(pitchRange: Pitch(intValue: viewConductor.lowNote) ... Pitch(intValue: viewConductor.highNote)),
                     noteOn: viewConductor.noteOnWithVerticalVelocity(pitch:point:), noteOff: viewConductor.noteOff),
            Keyboard(layout: .isomorphic(pitchRange:
                                            Pitch(intValue: 12 + viewConductor.rootIndex) ... Pitch(intValue: 84 + viewConductor.rootIndex),
                                         root: viewConductor.root,
                                         scale: viewConductor.scale),
                     noteOn: viewConductor.noteOnWithReversedVerticalVelocity(pitch:point:), noteOff: viewConductor.noteOff),
            Keyboard(layout: .guitar(),
                     noteOn: viewConductor.noteOn, noteOff: viewConductor.noteOff) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     text: pitch.note(in: .F).description,
                                     pressedColor: Color(PitchColor.newtonian[Int(pitch.pitchClass)]),
                                     alignment: .center)
                     },
            Keyboard(layout: .isomorphic(pitchRange: Pitch(48) ... Pitch(65))) { pitch, isActivated in
                KeyboardKey(pitch: pitch,
                            isActivated: isActivated,
                            text: pitch.note(in: .F).description,
                            pressedColor: Color(PitchColor.newtonian[Int(pitch.pitchClass)]))
            }
        ]
        
        HStack {
            Keyboard(layout: .verticalIsomorphic(pitchRange: Pitch(48) ... Pitch(77)))
                .frame(width: 100)
            VStack {
                NoteRangeStepperView(viewConductor: viewConductor)
                HStack {
                    RootStepperView(viewConductor: viewConductor)
                    ScaleStepperView(viewConductor: viewConductor)
                }
                ForEach(keyboards) { keyboard in
                    keyboard
                        .frame(minWidth: 100, minHeight: 100)
                }
                Keyboard(latching: true, noteOn: viewConductor.noteOn, noteOff: viewConductor.noteOff) { pitch, isActivated in
                    if isActivated {
                        ZStack {
                            Rectangle().foregroundColor(.black)
                            VStack {
                                Spacer()
                                Text(pitch.note(in: .C).description).font(.largeTitle)
                            }.padding()
                        }
                        
                    } else {
                        Rectangle().foregroundColor(viewConductor.randomColors[Int(pitch.intValue) % 12])
                    }
                }
                .frame(minWidth: 100, minHeight: 100)
            }
            Keyboard(
                layout: .verticalPiano(pitchRange: Pitch(48) ... Pitch(77),
                                       initialSpacerRatio: viewConductor.evenSpacingInitialSpacerRatio,
                                       spacerRatio: viewConductor.evenSpacingSpacerRatio,
                                       relativeBlackKeyWidth: viewConductor.evenSpacingRelativeBlackKeyWidth)
            )
            .frame(width: 100)
        }
        .ignoresSafeArea(edges:.horizontal)
        .background(Color.gray)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
