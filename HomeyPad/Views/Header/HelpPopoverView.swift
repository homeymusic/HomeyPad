import SwiftUI
import HomeyMusicKit

struct HelpPopoverView: View {
    
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
                    if (codi != .octave) {
                        GridRow {
                            codi.image
                            Text(codi.label.capitalized)
                        }
                    }
                }
                GridRow {
                    Text("Colors: Major-Minor")
                        .font(.caption)
                        .gridCellColumns(2)
                }
                ForEach(MajorMinor.allCases, id: \.self) { mami in
                    GridRow {
                        mami.image
                            .foregroundColor(Color(mami.color))
                        Text(mami.label.capitalized)
                    }
                }
//                GridRow {
//                    Text("Intervals")
//                        .font(Font.caption)
//                        .gridCellColumns(2)
//                }
//                ForEach(IntervalClass.allCases, id: \.self) { intervalClass in
//                    GridRow {
//                        intervalClass.consonanceDissonance.image
//                            .foregroundColor(Color(intervalClass.majorMinor.color))
//                        Text("\(intervalClass.label.capitalized)")
//                    }
//                }
                GridRow {
                    Text("Pitch Directions")
                        .font(.caption)
                        .gridCellColumns(2)
                }
                ForEach(PitchDirection.allCases, id: \.self) { pitchDirection in
                    GridRow {
                        pitchDirection.image
                            .aspectRatio(1.0, contentMode: .fit)
                            .foregroundColor(Color(pitchDirection.majorMinor.color))
                        Text(pitchDirection.label.capitalized)
                    }
                }
                GridRow {
                    Text("Chords")
                        .font(.caption)
                        .gridCellColumns(2)
                }
                ForEach(ChordShape.allCases, id: \.self) { chord in
                    GridRow {
                        Image(systemName: chord.icon)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: 17, height: 17)
                            .foregroundColor(Color(chord.majorMinor.color))
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
                            Image(systemName: "square")
                                .foregroundColor(.clear)
                                .overlay(
                                    Image(systemName: mode.pitchDirection.icon)
                                        .aspectRatio(1.0, contentMode: .fit)
                                        .foregroundColor(Color(mode.pitchDirection.majorMinor.color))
                                )
                            if (mode.scale == .pentatonic) {
                                Image(systemName: "square")
                                    .foregroundColor(.clear)
                                    .overlay(
                                        Image(systemName: Scale.pentatonic.icon)
                                            .aspectRatio(1.0, contentMode: .fit)
                                            .foregroundColor(Color(mode.majorMinor.color))
                                    )
                            }
                            Image(systemName: "square")
                                .foregroundColor(.clear)
                                .overlay(
                                    Image(systemName: mode.chordShape.icon)
                                        .aspectRatio(1.0, contentMode: .fit)
                                        .foregroundColor(Color(mode.chordShape.majorMinor.color))
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
                ForEach(InstrumentChoice.allCases, id: \.self) { instrumentType in
                        GridRow {
                            Text("\(instrumentType.midiChannelLabel)")
                            HStack {
                                Image(systemName: instrumentType.icon)
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(width: 17, height: 17)
                                Text(instrumentType.label)
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
                        Text("The design of Homey Pad including layout, color palette, user interactions and icon language is released under an [Attribution 4.0 International license (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).")
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
                            Text(" 2023-2024 [Homey Music](https://homeymusic.com), a registered trade name of Ballet, LLC. All other rights reserved. Homey Pad, Homey Visuals, Homey Work, and HomeyMusicKit are product names and trademarks of [Homey Music](https://homeymusic.com).")
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

