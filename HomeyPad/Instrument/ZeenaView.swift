import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct ZeenaView<Content>: View where Content: View {
    let pitchView: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var keyboardInstrument: KeyboardInstrument
    
    @EnvironmentObject var instrumentContext: InstrumentContext
    @EnvironmentObject var tonalContext: TonalContext
    
    // MARK: - Helper for rendering a key view for a given note
    func keyView(for note: Int) -> some View {
        let majorMinor: MajorMinor = Interval.majorMinor(forDistance: note - Int(tonalContext.tonicPitch.midiNote.number))
        if (majorMinor == .minor) {
            return AnyView(
                VStack(spacing: 0) {
                    if Pitch.isValid(note + 1) {
                        PitchContainerView(conductor: viewConductor,
                                           pitch: tonalContext.pitch(for: MIDINoteNumber(note + 1)),
                                           pitchView: pitchView)
                    } else {
                        Color.clear
                    }
                    if Pitch.isValid(note) {
                        PitchContainerView(conductor: viewConductor,
                                           pitch: tonalContext.pitch(for: MIDINoteNumber(note)),
                                           pitchView: pitchView)
                    } else {
                        Color.clear
                    }
                }
            )
        } else if (majorMinor == .neutral) {
            let intervalClass: IntervalClass = IntervalClass(distance: note - Int(tonalContext.tonicMIDI))
            if intervalClass == .seven {
                if Pitch.isValid(note) {
                    return AnyView(PitchContainerView(conductor: viewConductor,
                                                      pitch: tonalContext.pitch(for: MIDINoteNumber(note)),
                                                      pitchView: pitchView)
                        .overlay {
                            if Pitch.isValid(note - 1) && Pitch.isValid(note - 2) {
                                GeometryReader { proxy in
                                    let ttLength = viewConductor.tritoneLength(proxySize: proxy.size)
                                    ZStack {
                                        PitchContainerView(conductor: viewConductor,
                                                           pitch: tonalContext.pitch(for: MIDINoteNumber(note - 1)),
                                                           zIndex: 1,
                                                           pitchView: pitchView)
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
            } else if intervalClass != .six && Pitch.isValid(note) {
                return AnyView(PitchContainerView(conductor: viewConductor,
                                                  pitch: tonalContext.pitch(for: MIDINoteNumber(note)),
                                                  pitchView: pitchView))
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
            ForEach(keyboardInstrument.rowIndices, id: \.self
            ) { row in
                HStack(spacing: 0) {
                    ForEach(keyboardInstrument.colIndices(forTonic: Int(tonalContext.tonicPitch.midiNote.number),
                                                          pitchDirection: tonalContext.pitchDirection), id: \.self) { noteClass in
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
