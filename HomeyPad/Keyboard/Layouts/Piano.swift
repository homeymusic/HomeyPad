import SwiftUI

struct Piano<Content>: View where Content: View {
    let keyboardKey: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor
    let spacer: PianoSpacer
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach((-viewConductor.layoutRowsCols.rowsPerSide[.piano]!...viewConductor.layoutRowsCols.rowsPerSide[.piano]!).reversed(), id: \.self) { row in
                GeometryReader { geo in
                    ZStack(alignment: .topLeading) {
                        HStack(spacing: 0) {
                            ForEach(spacer.whiteMIDI, id: \.self) { col in
                                let midi: Int = col + 12 * row
                                if safeMIDI(midi: midi) {
                                    KeyContainer(conductor: viewConductor, pitch: viewConductor.allPitches[midi],                                  keyboardKey: keyboardKey)
                                        .frame(width: spacer.whiteKeyWidth(geo.size.width))
                                } else {
                                    Color.clear
                                        .frame(width: spacer.whiteKeyWidth(geo.size.width))
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 0) {
                                Rectangle().opacity(0)
                                    .frame(width: spacer.initialSpacerWidth(geo.size.width))
                                ForEach(spacer.midiBoundedByNaturals, id: \.self) { col in
                                    let midi: Int = col + 12 * row
                                    if Pitch.accidental(midi: midi) {
                                        ZStack {
                                            if safeMIDI(midi: midi) {
                                                KeyContainer(conductor: viewConductor,
                                                             pitch: viewConductor.allPitches[midi],
                                                             zIndex: 1,
                                                             keyboardKey: keyboardKey)
                                            } else {
                                                Color.clear
                                            }
                                        }
                                        .frame(width: spacer.blackKeyWidth(geo.size.width))
                                    } else {
                                        Rectangle().opacity(0)
                                            .frame(width: spacer.blackKeySpacerWidth(geo.size.width, midi: midi))
                                    }
                                }
                            }
                            
                            Spacer().frame(height: geo.size.height * (1 - spacer.relativeBlackKeyHeight))
                        }
                    }
                    .animation(viewConductor.animationStyle, value: viewConductor.tonicMIDI)
                }
                .clipShape(Rectangle())
            }
        }
    }
}
