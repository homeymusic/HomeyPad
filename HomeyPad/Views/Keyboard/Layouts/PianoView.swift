import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct PianoView<Content>: View where Content: View {
    let pitchView: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor
    @EnvironmentObject var tonalContext: TonalContext

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
        if Pitch.isValid(note) {
            let pitch = tonalContext.pitch(for: MIDINoteNumber(note))
            if pitch.isNatural {
                return AnyView(
                    PitchContainerView(conductor: viewConductor,
                                         pitch: pitch,
                                         pitchView: pitchView)
                    .overlay {
                        if Pitch.isValid(note - 1) {
                            let pitch = tonalContext.pitch(for: MIDINoteNumber(note - 1))
                            if !pitch.isNatural {
                                GeometryReader { proxy in
                                    ZStack {
                                        PitchContainerView(conductor: viewConductor,
                                                                 pitch: pitch,
                                                                 zIndex: 1,
                                                                 pitchView: pitchView)
                                        .frame(width: proxy.size.width / viewConductor.goldenRatio,
                                               height: proxy.size.height / viewConductor.goldenRatio)
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
                    ForEach(viewConductor.nearbyNotes, id: \.self) { noteClass in
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
