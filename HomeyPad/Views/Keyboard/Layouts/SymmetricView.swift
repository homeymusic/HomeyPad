import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct SymmetricView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    var viewConductor: ViewConductor

    // MARK: - Helper for rendering a key view for a given note
    func keyView(for note: Int) -> some View {
        let majorMinor: MajorMinor = Interval.majorMinor(note - Int(viewConductor.tonalContext.tonicPitch.midiNote.number))
        if (majorMinor == .minor) {
            return AnyView(
                VStack(spacing: 0) {
                    if Pitch.isValidPitch(note + 1) {
                        KeyboardKeyContainerView(conductor: viewConductor,
                                                 pitch: Pitch.pitch(for: MIDINoteNumber(note + 1)),
                                                 keyboardKeyView: keyboardKeyView)
                    } else {
                        Color.clear
                    }
                    if Pitch.isValidPitch(note) {
                        KeyboardKeyContainerView(conductor: viewConductor,
                                                 pitch: Pitch.pitch(for: MIDINoteNumber(note)),
                                                 keyboardKeyView: keyboardKeyView)
                    } else {
                        Color.clear
                    }
                }
            )
        } else if (majorMinor == .neutral) {
            let intervalClass: IntervalClass = IntervalClass(distance: note - Int(viewConductor.tonalContext.tonicMIDI))
            if intervalClass == .seven {
                if Pitch.isValidPitch(note) {
                    return AnyView(KeyboardKeyContainerView(conductor: viewConductor,
                                                    pitch: Pitch.pitch(for: MIDINoteNumber(note)),
                                                    keyboardKeyView: keyboardKeyView)
                    .overlay {
                        if Pitch.isValidPitch(note - 1) && Pitch.isValidPitch(note - 2) {
                            GeometryReader { proxy in
                                let ttLength = viewConductor.tritoneLength(proxySize: proxy.size)
                                ZStack {
                                    KeyboardKeyContainerView(conductor: viewConductor,
                                                             pitch: Pitch.pitch(for: MIDINoteNumber(note - 1)),
                                                             zIndex: 1,
                                                             keyboardKeyView: keyboardKeyView)
                                    .frame(width: ttLength, height: ttLength)
                                }
                                .offset(x: -ttLength / 2.0,
                                        y: proxy.size.height / 2.0 - ttLength / 2.0)
                            }
                        }
                    })
                } else {
                    return AnyView(Color.clear)
                }
            } else if intervalClass != .six && Pitch.isValidPitch(note) {
                return AnyView(KeyboardKeyContainerView(conductor: viewConductor,
                                                        pitch: Pitch.pitch(for: MIDINoteNumber(note)),
                                                        keyboardKeyView: keyboardKeyView))
            } else {
                return AnyView(EmptyView())
            }
        } else {
            return AnyView(EmptyView())
        }
    }
    
    // MARK: - Main Body
    var body: some View {
        VStack(spacing: 0) {
            ForEach(
                viewConductor.layoutRows,
                id: \.self
            ) { row in
                HStack(spacing: 0) {
                    ForEach(viewConductor.layoutCols, id: \.self) { noteClass in
                        let note = Int(noteClass) + 12 * row
                        keyView(for: note)
                    }
                }
            }
        }
        .animation(viewConductor.animationStyle, value: viewConductor.tonalContext.tonicMIDI)
        .clipShape(Rectangle())
    }
}
