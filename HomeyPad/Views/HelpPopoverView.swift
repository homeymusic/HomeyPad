//
//  HelpPopoverView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 4/14/24.
//

import SwiftUI

struct HelpPopoverView: View {
    
    static let mamiIcon: String = "paintbrush.pointed.fill"
    
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
                        Image(systemName: codi.icon)
                            .gridColumnAlignment(.center)
                            .foregroundColor(.white)
                        Text(codi.label.capitalized)
                    }
                }
                GridRow {
                    Text("Colors: Major-Minor")
                        .font(.caption)
                        .gridCellColumns(2)
                }
                ForEach(MajorMinor.allCases, id: \.self) { mami in
                    GridRow {
                        Image(systemName: HelpPopoverView.mamiIcon)
                            .gridColumnAlignment(.center)
                            .foregroundColor(Color(mami.color))
                        Text(mami.label.capitalized)
                    }
                }
                GridRow {
                    Text("Intervals")
                        .font(Font.caption)
                        .gridCellColumns(2)
                }
                ForEach(IntervalClass.allCases, id: \.self) { intervalClass in
                    GridRow {
                        Image(systemName: intervalClass.interval.consonanceDissonance.icon)
                            .foregroundColor(Color(intervalClass.interval.majorMinor.color))
                        Text("\(intervalClass.interval.shorthand) \(intervalClass.interval.label.capitalized)")
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
                            .gridColumnAlignment(.center)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: 17, height: 17)
                            .foregroundColor(Color(chord.majorMinor.color))
                        Text(chord.rawValue.capitalized)
                    }
                }
                GridRow {
                    Text("Pitch Directions")
                        .font(.caption)
                        .gridCellColumns(2)
                }
                ForEach(PitchDirection.allCases, id: \.self) { pitchDirection in
                    GridRow {
                        Image(systemName: pitchDirection.icon)
                            .gridColumnAlignment(.center)
                            .aspectRatio(1.0, contentMode: .fit)
                            .foregroundColor(Color(pitchDirection.majorMinor.color))
                        Text(pitchDirection.label.capitalized)
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
                            Image(systemName: "square")
                                .foregroundColor(.clear)
                                .overlay(
                                    Image(systemName: mode.chordShape.icon)
                                        .aspectRatio(1.0, contentMode: .fit)
                                        .foregroundColor(Color(mode.chordShape.majorMinor.color))
                                )
                        }
                        .gridColumnAlignment(.center)
                        Text("\(mode.letter) \(mode.label.capitalized)")
                    }
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
                            Text(" 2023-2024 [Homey Music](https://homeymusic.com), a registered trade name of Ballet, LLC. All other rights reserved. Homey Pad is a product name and trademark of [Homey Music](https://homeymusic.com).")
                        )
                        .gridCellColumns(2)
                    }
                    GridRow {
                        Text("The Yamaha Disklavier Pro soundfont was produced by [Zenvoid](https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html) from samples made by [Zenph Studios](https://www.nytimes.com/2007/03/12/arts/music/12conn.html) for [One Laptop Per Child](http://wiki.laptop.org/go/Sound_samples) and is used by Homey Pad under a [Creative Commons Attribution 3.0 license](https://creativecommons.org/licenses/by/3.0/).")
                            .gridCellColumns(2)
                    }
                }
                .font(.footnote)
            }
            .frame(width: 250)
            .padding(10)
        }
    }
}

