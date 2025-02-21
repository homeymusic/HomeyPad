import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct PianoView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    var viewConductor: ViewConductor

    func offset(for pitch: Pitch) -> CGFloat {
        switch pitch.pitchClass {
        case .one:
            -6.0 / 16.0
        case .three:
            -3.0 / 16.0
        case .six:
            -6.0 / 16.0
        case .eight:
            -5.0 / 16.0
        case .ten:
            -3.0 / 16.0
        default:
            0.0
        }
    }
    
    // MARK: - Helper for rendering a key view for a given note
    func keyView(for note: Int) -> some View {
        if Pitch.isValidPitch(note) {
            let pitch = Pitch.pitch(for: MIDINoteNumber(note))
            if pitch.isNatural {
                return AnyView(
                    KeyboardKeyContainerView(conductor: viewConductor,
                                         pitch: pitch,
                                         keyboardKeyView: keyboardKeyView)
                    .overlay {
                        if Pitch.isValidPitch(note - 1) {
                            let pitch = Pitch.pitch(for: MIDINoteNumber(note - 1))
                            if !pitch.isNatural {
                                GeometryReader { proxy in
                                    ZStack {
                                        KeyboardKeyContainerView(conductor: viewConductor,
                                                                 pitch: pitch,
                                                                 zIndex: 1,
                                                                 keyboardKeyView: keyboardKeyView)
                                        .frame(width: 0.5625 * proxy.size.width, height: 0.53 * proxy.size.height)
                                    }
                                    .offset(x: offset(for: pitch) * proxy.size.width, y: 0.0)
                                }
                            }
                        }
                    }
                )
            } else {
                return AnyView(EmptyView())
            }
        } else {
            return AnyView(Color.clear)
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
