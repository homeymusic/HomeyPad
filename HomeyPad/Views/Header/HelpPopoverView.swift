import SwiftUI
import HomeyMusicKit

struct HelpPopoverView: View {
    @Environment(InstrumentalContext.self) var instrumentalContext
    @Environment(NotationalContext.self) var notationalContext
    @State var colorPalette: ColorPalette?
    @Environment(\.modelContext) var modelContext

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Text("Homey Pad")
                .font(.headline)
            Spacer()
        }
        .padding(5)
        Divider()
            .padding(.bottom, 3)
        ScrollView(.vertical) {
            Grid(alignment: .leading, horizontalSpacing: 3, verticalSpacing: 5) {
                GridRow {
                    Text("Legend")
                        .font(.subheadline)
                        .gridCellColumns(2)
                }
                GridRow {
                    Text("Icons: Consonance-Dissonance")
                        .font(.caption)
                        .gridCellColumns(2)
                }
                ForEach(ConsonanceDissonance.allCases, id: \.self) { codi in
                    GridRow {
                        codi.image
                        Text(codi.label.capitalized)
                    }
                }
                GridRow {
                    Text("Colors: Major-Minor")
                        .font(.caption)
                        .gridCellColumns(2)
                }
                ForEach(MajorMinor.allCases, id: \.self) { mami in
                    let imageColor = colorPalette?.majorMinorColor(majorMinor: mami) ?? .clear
                    GridRow {
                        mami.image
                            .foregroundColor(imageColor)
                        Text(mami.label.capitalized)
                    }
                }
                GridRow {
                    Text("Pitch Directions")
                        .font(.caption)
                        .gridCellColumns(2)
                }
                ForEach(PitchDirection.allCases, id: \.self) { pitchDirection in
                    let imageColor = colorPalette?.majorMinorColor(majorMinor: pitchDirection.majorMinor) ?? .clear
                    GridRow {
                        pitchDirection.image
                            .aspectRatio(1.0, contentMode: .fit)
                            .foregroundColor(imageColor)
                        Text(pitchDirection.label.capitalized)
                    }
                }
                GridRow {
                    Text("Chords")
                        .font(.caption)
                        .gridCellColumns(2)
                }
                ForEach(Chord.allCases, id: \.self) { chord in
                    let imageColor = colorPalette?.majorMinorColor(majorMinor: chord.majorMinor) ?? .clear
                    GridRow {
                        Image(systemName: chord.icon)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: 17, height: 17)
                            .foregroundColor(imageColor)
                        Text(chord.rawValue.capitalized)
                    }
                }
                GridRow {
                    Text("Modes")
                        .font(.caption)
                        .gridCellColumns(2)
                }
                ForEach(Mode.allCases, id: \.self) { mode in
                    GridRow {
                        HStack(spacing: 0) {
                            let pitchDirectionImageColor = colorPalette?.majorMinorColor(majorMinor: mode.pitchDirection.majorMinor) ?? .clear
                            Image(systemName: "square")
                                .foregroundColor(.clear)
                                .overlay(
                                    Image(systemName: mode.pitchDirection.icon)
                                        .aspectRatio(1.0, contentMode: .fit)
                                        .foregroundColor(pitchDirectionImageColor)
                                )
                            if (mode.scale == .pentatonic) {
                                let modeImageColor = colorPalette?.majorMinorColor(majorMinor: mode.majorMinor) ?? .clear
                                Image(systemName: "square")
                                    .foregroundColor(.clear)
                                    .overlay(
                                        Image(systemName: Scale.pentatonic.icon)
                                            .aspectRatio(1.0, contentMode: .fit)
                                            .foregroundColor(modeImageColor)
                                    )
                            }
                            let chordShapeImageColor = colorPalette?.majorMinorColor(majorMinor: mode.chordShape.majorMinor) ?? .clear
                            Image(systemName: "square")
                                .foregroundColor(.clear)
                                .overlay(
                                    Image(systemName: mode.chordShape.icon)
                                        .aspectRatio(1.0, contentMode: .fit)
                                        .foregroundColor(chordShapeImageColor)
                                )
                        }
                        Text("\(mode.label.capitalized)")
                    }
                }
                GridRow {
                    Text("MIDI Channels")
                        .font(.caption)
                        .gridCellColumns(2)
                }
                ForEach(InstrumentChoice.allCases, id: \.self) { instrumentChoice in
                    GridRow {
                        Text("\(instrumentChoice.midiChannelLabel)")
                        HStack {
                            Image(systemName: instrumentChoice.icon)
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(width: 17, height: 17)
                            Text(instrumentChoice.label)
                        }
                    }
                }
                GridRow {
                    Text("MIDI CC Parameters")
                        .font(.caption)
                        .gridCellColumns(2)
                }
                GridRow {
                    Text("16")
                    Text("Tonic: 0 to 127 Notes")
                }
                GridRow {
                    Text("17")
                    Text("Direction: < 0, = 1, > 2")
                }
                GridRow {
                    Text("18")
                    Text("Mode: 0 ION to 11 LOC")
                }
                Divider()
                    .padding(3)
                Group {
                    GridRow {
                        Text("Legal")
                            .font(.subheadline)
                            .gridCellColumns(2)
                    }
                    GridRow {
                        Text("The design of Homey Pad including layout, color palette, user interactions and icon language is released under an [Attribution-NonCommercial 4.0 International license (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/).")
                            .gridCellColumns(2)
                    }
                    GridRow {
                        (
                            Text("The Homey Pad software is released under an [MIT License](https://opensource.org/license/mit/) and is available on [GitHub](https://github.com/homeymusic/homeypad).")
                        )
                        .gridCellColumns(2)
                    }
                    GridRow {
                        (
                            Text(Image(systemName: "c.circle")) +
                            Text(" 2023-2025 [Homey Music](https://homeymusic.com), a registered trade name of Ballet, LLC. All other rights reserved. Homey Pad, Homey Visuals, Homey Work, and HomeyMusicKit are product names and trademarks of [Homey Music](https://homeymusic.com).")
                        )
                        .gridCellColumns(2)
                    }
                }
                .font(.footnote)
                .lineLimit(nil)
            }
            .lineLimit(1)
            .frame(width: 270)
            .padding(10)
        }
        .onAppear {
            colorPalette = ColorPalette.fetchColorPalette(
                colorPaletteName: notationalContext.colorPaletteName[instrumentalContext.instrumentChoice]!,
                modelContext: modelContext
            )
        }
        .onChange(of: notationalContext.colorPaletteName[instrumentalContext.instrumentChoice]) {
            colorPalette = ColorPalette.fetchColorPalette(
                colorPaletteName: notationalContext.colorPaletteName[instrumentalContext.instrumentChoice]!,
                modelContext: modelContext
            )
        }
    }
}

