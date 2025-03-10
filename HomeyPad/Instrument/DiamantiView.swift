import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct DiamantiView: View {
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var diamanti: Diamanti
    
    @EnvironmentObject var instrumentalContext: InstrumentalContext
    @EnvironmentObject var tonalContext: TonalContext
    
    // MARK: - Helper for rendering a key view for a given note
    func keyView(for note: Int) -> some View {
        let majorMinor: MajorMinor = Interval.majorMinor(forDistance: note - Int(tonalContext.tonicPitch.midiNote.number))
        if (majorMinor == .minor) {
            return AnyView(
                VStack(spacing: 0) {
                    if Pitch.isValid(note + 1) {
                        PitchContainerView(conductor: viewConductor,
                                           pitch: tonalContext.pitch(for: MIDINoteNumber(note + 1)))
                    } else {
                        Color.clear
                    }
                    if Pitch.isValid(note) {
                        PitchContainerView(conductor: viewConductor,
                                           pitch: tonalContext.pitch(for: MIDINoteNumber(note)))
                    } else {
                        Color.clear
                    }
                }
            )
        } else if (majorMinor == .neutral) {
            let intervalClass: IntervalClass = IntervalClass(distance: note - Int(tonalContext.tonicMIDI))
            if intervalClass == .seven {
                if Pitch.isValid(note) {
                    return AnyView(PitchContainerView(
                        conductor: viewConductor,
                        pitch: tonalContext.pitch(for: MIDINoteNumber(note)),
                        containerType: .span
                    )
                        .overlay {
                            if Pitch.isValid(note - 1) && Pitch.isValid(note - 2) {
                                GeometryReader { proxy in
                                    let ttLength = DiamantiView.tritoneLength(proxySize: proxy.size)
                                    ZStack {
                                        PitchContainerView(
                                            conductor: viewConductor,
                                            pitch: tonalContext.pitch(for: MIDINoteNumber(note - 1)),
                                            zIndex: 1,
                                            containerType: .diamond
                                        )
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
                return AnyView(PitchContainerView(
                    conductor: viewConductor,
                    pitch: tonalContext.pitch(for: MIDINoteNumber(note)),
                    containerType: .span
                ))
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
            ForEach(diamanti.rowIndices, id: \.self
            ) { row in
                HStack(spacing: 0) {
                    ForEach(diamanti.colIndices(forTonic: Int(tonalContext.tonicPitch.midiNote.number),
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
    
    static func tritoneLength(proxySize: CGSize) -> CGFloat {
        return min(proxySize.height * 1/3, proxySize.width)
    }

}
