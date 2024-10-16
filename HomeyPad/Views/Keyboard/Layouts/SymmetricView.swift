import SwiftUI
import HomeyMusicKit

struct SymmetricView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    var viewConductor: ViewConductor
    @StateObject private var tonalContext = TonalContext.shared

    var body: some View {
        VStack(spacing: 0) {
            ForEach((-viewConductor.layoutRowsCols.rowsPerSide[.symmetric]!...viewConductor.layoutRowsCols.rowsPerSide[.symmetric]!).reversed(), id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(viewConductor.layoutNotes, id: \.self) { noteClass in
                        let note: Int = Int(noteClass) + 12 * row
                        let majorMinor: MajorMinor = Interval.majorMinor(midi: note, tonicMIDI: Int(tonalContext.tonicMIDI))
                        if majorMinor == .minor {
                            VStack(spacing: 0.0)  {
                                if MIDIHelper.isValidMIDI(note: note + 1) {
                                    KeyboardKeyContainerView(conductor: viewConductor,
                                                             pitch: tonalContext.allPitches[note + 1],
                                                             keyboardKeyView: keyboardKeyView)
                                } else {
                                    Color.clear
                                }
                                if MIDIHelper.isValidMIDI(note: note) {
                                    KeyboardKeyContainerView(conductor: viewConductor,
                                                             pitch: tonalContext.allPitches[note],
                                                             keyboardKeyView: keyboardKeyView)
                                } else {
                                    Color.clear
                                }
                            }
                        } else if majorMinor == .neutral {
                            let intervalClass: IntegerNotation = Interval.intervalClass(midi: note, tonicMIDI: Int(tonalContext.tonicMIDI))
                            if intervalClass == .seven { // perfect fifth takes care of rendering the tritone above it
                                if MIDIHelper.isValidMIDI(note: note) {
                                    KeyboardKeyContainerView(conductor: viewConductor,
                                                             pitch: tonalContext.allPitches[note],
                                                             keyboardKeyView: keyboardKeyView)
                                    .overlay() { // render tritone as overlay
                                        // only render tritone if P4, tt and P5 are safe
                                        if MIDIHelper.isValidMIDI(note: note - 1) && MIDIHelper.isValidMIDI(note: note - 2) {
                                            GeometryReader { proxy in
                                                let ttLength = viewConductor.tritoneLength(proxySize: proxy.size)
                                                ZStack {
                                                    KeyboardKeyContainerView(conductor: viewConductor,
                                                                             pitch: tonalContext.allPitches[note-1], // tritone
                                                                             zIndex: 1,
                                                                             keyboardKeyView: keyboardKeyView)
                                                    .frame(width: ttLength, height: ttLength)
                                                }
                                                .offset(x: -ttLength / 2.0, y: proxy.size.height / 2.0 - ttLength / 2.0)
                                            }
                                        }
                                    }
                                } else {
                                    Color.clear
                                }
                                
                            } else if intervalClass != .six { // skip tritone
                                if MIDIHelper.isValidMIDI(note: note) {
                                    KeyboardKeyContainerView(conductor: viewConductor,
                                                             pitch: tonalContext.allPitches[note],
                                                             keyboardKeyView: keyboardKeyView)
                                } else {
                                    Color.clear
                                }
                            }
                        }
                    }
                }
            }
        }
        .animation(viewConductor.animationStyle, value: tonalContext.tonicMIDI)
        .clipShape(Rectangle())
    }
    
}

