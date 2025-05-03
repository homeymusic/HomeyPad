import SwiftUI
import HomeyMusicKit

struct HelpPopoverView: View {
    @Environment(AppContext.self) var appContext
    @Environment(\.modelContext) var modelContext

    var body: some View {
        
        let colorPalette: ColorPalette = modelContext.singletonInstrument(for: appContext.instrumentType).colorPalette
        
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
                ForEach(MajorMinor.allCases.sorted { $0.majorMinorMagnitude > $1.majorMinorMagnitude }, id: \.self) { mami in
                    let imageColor = colorPalette.majorMinorColor(majorMinor: mami)
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
                ForEach(PitchDirection.allCases.sorted { $0.majorMinorMagnitude > $1.majorMinorMagnitude }, id: \.self) { pitchDirection in
                    let imageColor = colorPalette.majorMinorColor(majorMinor: pitchDirection.majorMinor)
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
                ForEach(Chord.allCases.sorted { $0.majorMinorMagnitude > $1.majorMinorMagnitude },
                        id: \.self) { chord in
                    let imageColor = colorPalette.majorMinorColor(majorMinor: chord.majorMinor)
                    GridRow {
                        chord.image
                            .aspectRatio(1.0, contentMode: .fit)
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
                GridRow {
                    Text("Heptatonic")
                        .font(.caption2)
                        .gridCellColumns(2)
                }
                let heptatonicModes = Mode.allCases
                    .filter { $0.scaleCount == .heptatonic }
                    .sorted { $0.majorMinorMagnitude > $1.majorMinorMagnitude }
                ForEach(heptatonicModes, id: \.self) { mode in
                    modeRow(mode: mode, colorPalette: colorPalette)
                }
                GridRow {
                    Text("Pentatonic")
                        .font(.caption2)
                        .gridCellColumns(2)
                }
                let pentatonicModes = Mode.allCases
                    .filter { $0.scaleCount == .pentatonic }
                    .sorted { $0.majorMinorMagnitude > $1.majorMinorMagnitude }
                ForEach(pentatonicModes, id: \.self) { mode in
                    modeRow(mode: mode, colorPalette: colorPalette)
                }
                GridRow {
                    Text("MIDI Channels")
                        .font(.caption)
                        .gridCellColumns(2)
                }
                ForEach(InstrumentType.allInstruments, id: \.self) { instrumentType in
                    GridRow {
                        Image(systemName: instrumentType.midiChannel.icon)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: 17, height: 17)
                        HStack {
                            Image(systemName: instrumentType.icon)
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(width: 17, height: 17)
                            Text(instrumentType.label.capitalized)
                        }
                    }
                }
                GridRow {
                    Text("MIDI CC Parameters")
                        .font(.caption)
                        .gridCellColumns(2)
                }
                GridRow {
                    Image(systemName: "16.square")
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: 17, height: 17)
                    Text("Tonic: 0 to 127 Notes")
                }
                GridRow {
                    Image(systemName: "17.square")
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: 17, height: 17)
                    Text("Direction: < 0, = 1, > 2")
                }
                GridRow {
                    Image(systemName: "18.square")
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: 17, height: 17)
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
    }
}

func modeRow(mode: Mode, colorPalette: ColorPalette) -> some View {
    GridRow {
        HStack(spacing: 0) {
            let pitchDirectionImageColor = colorPalette.majorMinorColor(majorMinor: mode.pitchDirection.majorMinor)
            Image(systemName: "square")
                .foregroundColor(.clear)
                .overlay(
                    mode.pitchDirection.image
                        .aspectRatio(1.0, contentMode: .fit)
                        .foregroundColor(pitchDirectionImageColor)
                )
            let chordShapeImageColor = colorPalette.majorMinorColor(majorMinor: mode.chordShape.majorMinor)
            Image(systemName: "square")
                .foregroundColor(.clear)
                .overlay(
                    mode.image
                        .aspectRatio(1.0, contentMode: .fit)
                        .foregroundColor(chordShapeImageColor)
                )
        }
        Text(mode.label.capitalized)
    }
}
