//
//  SettingsView.swift
//
//  Created by Brian McAuliff Mulloy on 9/12/23.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Spacer()
                Text("Homey Pad")
                    .font(.headline)
                Spacer()
            }
            .padding(.top, 10)
            Divider()
            ScrollView {
                Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 5) {
                    Group { // icons
                        GridRow {
                            Text("Legend")
                                .font(.subheadline)
                                .gridCellColumns(2)
                        }
                    }
                    Group { // icons
                        GridRow {
                            Text("Icons: Consonance-Dissonance")
                                .font(.caption)
                                .gridCellColumns(2)
                        }
                        GridRow {
                            NitterHouse()
                                .stroke(lineWidth: 2)
                                .gridColumnAlignment(.center)
                                .frame(width: 17, height: 17)
                            Text("stable, perfect")
                        }
                        .foregroundColor(.white)
                        GridRow {
                            Image(systemName: "diamond.fill")
                            Text("tottering, pleasant")
                        }
                        .foregroundColor(.white)
                        GridRow {
                            Image(systemName: "circle.fill")
                            Text("rolling, unpleasant")
                        }
                        .foregroundColor(.white)
                    }
                    Group { // colors
                        GridRow {
                            Text("Colors: Major-Minor")
                                .font(.caption)
                                .gridCellColumns(2)
                        }
                        GridRow {
                            Image(systemName: "paintbrush.pointed.fill")
                            Text("sheltered, neutral")
                        }
                        .foregroundColor(Default.homeColor)
                        GridRow {
                            Image(systemName: "paintbrush.pointed.fill")
                            Text("sunny, major")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "paintbrush.pointed.fill")
                            Text("cloudy, minor")
                        }
                        .foregroundColor(Default.minorColor)
                        GridRow {
                            Image(systemName: "paintbrush.pointed.fill")
                            Text("windy, strange")
                        }
                        .foregroundColor(Default.tritoneColor)
                    }
                    Group { //
                        GridRow {
                            Text("Intervals")
                                .font(.caption)
                                .gridCellColumns(2)
                        }
                        GridRow {
                            NitterHouse()
                                .stroke(lineWidth: 2)
                                .gridColumnAlignment(.center)
                                .frame(width: 17, height: 17)
                            Text("neutral perfect")
                        }
                        .foregroundColor(Default.homeColor)
                        GridRow {
                            Image(systemName: "diamond.fill")
                            Text("major pleasant")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "diamond.fill")
                            Text("minor pleasant")
                        }
                        .foregroundColor(Default.minorColor)
                        GridRow {
                            Image(systemName: "circle.fill")
                            Text("major unpleasant")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "circle.fill")
                            Text("minor unpleasant")
                        }
                        .foregroundColor(Default.minorColor)
                        GridRow {
                            Image(systemName: "circle.fill")
                            Text("strange unpleasant")
                        }
                        .foregroundColor(Default.tritoneColor)
                    }
                    Group {
                        GridRow {
                            Text("Chords")
                                .font(.caption)
                                .gridCellColumns(2)
                        }
                        GridRow {
                            Image(systemName: "plus.square.fill")
                            Text("major chord")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "minus.square.fill")
                            Text("minor chord")
                        }
                        .foregroundColor(Default.minorColor)
                        GridRow {
                            Image(systemName: "multiply.square.fill")
                            Text("inverted major chord")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "i.square.fill")
                            Text("inverted minor chord")
                        }
                        .foregroundColor(Default.minorColor)
                        GridRow {
                            Image(systemName: "paintpalette")
                                .symbolRenderingMode(.multicolor)
                            Text("chromatic elements")
                                .foregroundColor(Default.chromaticColor)
                        }
                        GridRow {
                            Text("Pitch Movements")
                                .font(.caption)
                                .gridCellColumns(2)
                        }
                        GridRow {
                            Image(systemName: "greaterthan.square.fill")
                            Text("upward emphasis")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "lessthan.square.fill")
                            Text("downward emphasis")
                        }
                        .foregroundColor(Default.minorColor)
                    }
                    Divider()
                        .gridCellUnsizedAxes(.horizontal)
                    Group {
                        GridRow {
                            Text("Help")
                                .font(.subheadline)
                                .gridCellColumns(2)
                        }
                        GridRow {
                            Image(systemName: "questionmark.video")
                            Link("Videos", destination: URL(string: "https://homeymusic.com/products/homeypad/videos")!)
                        }
                        GridRow {
                            Image(systemName: "person.crop.circle.badge.questionmark")
                            Link("Forums", destination: URL(string: "https://homeymusic.com/products/homeypad/forums")!)
                        }
                        GridRow {
                            Image(systemName: "questionmark.folder")
                            Link("Guides", destination: URL(string: "https://homeymusic.com/products/homeypad/guides")!)
                        }
                    }
                    Divider()
                        .gridCellUnsizedAxes(.horizontal)
                    Group {
                        GridRow {
                            Text("Legal")
                                .font(.subheadline)
                                .gridCellColumns(2)
                        }
                        GridRow {
                            Text("The design of [Homey Pad](https://homeymusic.com/products/homeypad) including layout, color palette, user interactions and icon language is released under an [Attribution 4.0 International license (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).")
                                .gridCellColumns(2)
                        }
                        GridRow {
                            (
                                Text("The [Homey Pad](https://homeymusic.com/products/homeypad) software is released under an [MIT License](https://opensource.org/license/mit/) and is available on [GitHub](https://github.com/homeymusic/homeypad).")
                            )
                            .gridCellColumns(2)
                        }
                        GridRow {
                            (
                                Text(Image(systemName: "c.circle")) +
                                Text(" 2023 [Homey Music](https://homeymusic.com), a registered trade name of Ballet, LLC. All other rights reserved. [Homey Pad](https://homeymusic.com/products/homeypad) is a product name and trademark of [Homey Music](https://homeymusic.com).")
                            )
                            .gridCellColumns(2)
                        }
                        GridRow {
                            Text("The Yamaha Disklavier Pro soundfont was produced by [Zenvoid](https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html) from samples made by [Zenph Studios](https://www.nytimes.com/2007/03/12/arts/music/12conn.html) for [One Laptop Per Child](http://wiki.laptop.org/go/Sound_samples) and is used by [Homey Pad](https://homeymusic.com/products/homeypad) under a [Creative Commons Attribution 3.0 license](https://creativecommons.org/licenses/by/3.0/).")
                                .gridCellColumns(2)
                        }
                    }
                    .font(.footnote)
                }
                .padding([.leading, .trailing, .bottom], 10)
                .frame(width: 250)
            }
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
