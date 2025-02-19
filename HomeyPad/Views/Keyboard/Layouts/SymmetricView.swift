import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct SymmetricView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    var viewConductor: ViewConductor
    @StateObject private var tonalContext = TonalContext.shared

    // MARK: - Helper for rendering a key view for a given note
    func keyView(for note: Int) -> some View {
        let majorMinor: MajorMinor = Interval.majorMinor(note - Int(tonalContext.tonicMIDI))
        switch majorMinor {
        case .minor:
            return AnyView(
                VStack(spacing: 0) {
                    if MIDIConductor.isValidMIDI(note + 1) {
                        KeyboardKeyContainerView(conductor: viewConductor,
                                                 pitch: Pitch.pitch(for: MIDINoteNumber(note + 1)),
                                                 keyboardKeyView: keyboardKeyView)
                    } else {
                        Color.clear
                    }
                    if MIDIConductor.isValidMIDI(note) {
                        KeyboardKeyContainerView(conductor: viewConductor,
                                                 pitch: Pitch.pitch(for: MIDINoteNumber(note)),
                                                 keyboardKeyView: keyboardKeyView)
                    } else {
                        Color.clear
                    }
                }
            )
            
        case .neutral:
            let intervalClass: IntervalClass = IntervalClass(distance: note - Int(tonalContext.tonicMIDI))
            if intervalClass == .seven {
                return AnyView(
                    KeyboardKeyContainerView(conductor: viewConductor,
                                             pitch: Pitch.pitch(for: MIDINoteNumber(note)),
                                             keyboardKeyView: keyboardKeyView)
                    .overlay {
                        if MIDIConductor.isValidMIDI(note - 1) && MIDIConductor.isValidMIDI(note - 2) {
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
                    }
                )
            } else if intervalClass != .six && MIDIConductor.isValidMIDI(note) {
                return AnyView(KeyboardKeyContainerView(conductor: viewConductor,
                                               pitch: Pitch.pitch(for: MIDINoteNumber(note)),
                                               keyboardKeyView: keyboardKeyView))
            } else {
                return AnyView(Color.clear)
            }
            
        default:
            return AnyView(Color.clear)
        }
    }
    
    // MARK: - Main Body
    var body: some View {
        VStack(spacing: 0) {
            ForEach(
                (-viewConductor.layoutRowsCols.rowsPerSide[.symmetric]!...viewConductor.layoutRowsCols.rowsPerSide[.symmetric]!).reversed(),
                id: \.self
            ) { row in
                HStack(spacing: 0) {
                    ForEach(viewConductor.layoutNotes, id: \.self) { noteClass in
                        let note = Int(noteClass) + 12 * row
                        keyView(for: note)
                    }
                }
            }
        }
        .animation(viewConductor.animationStyle, value: tonalContext.tonicMIDI)
        .clipShape(Rectangle())
    }
}
