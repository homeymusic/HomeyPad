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
                Grid(alignment: .leading, horizontalSpacing: 3, verticalSpacing: 5) {
                    GridRow {
                        Text("Legend")
                            .font(.subheadline)
                            .padding(.bottom, 2)
                            .gridCellUnsizedAxes(.horizontal)
                            .gridCellColumns(3)
                    }
                    Group { // icons
                        GridRow {
                            Text("Icons: Consonance-Dissonance")
                                .font(.caption)
                                .gridCellUnsizedAxes(.horizontal)
                                .gridCellColumns(3)
                                .padding(.top, 10)
                        }
                        GridRow {
                            Image(systemName: "house")
                                .gridColumnAlignment(.center)
                            Text("Home")
                            Text("stable, pure, perfect")
                        }
                        .foregroundColor(.white)
                        GridRow {
                            Image(systemName: "diamond.fill")
                            Text("Gem")
                            Text("tottering, rich, consonant")
                        }
                        .foregroundColor(.white)
                        GridRow {
                            Image(systemName: "circle.fill")
                            Text("Stone")
                            Text("rolling, harsh, dissonant")
                        }
                        .foregroundColor(.white)
                    }
                    Group { // colors
                        GridRow {
                            Text("Colors: Major-Minor")
                                .font(.caption)
                                .gridCellUnsizedAxes(.horizontal)
                                .gridCellColumns(3)
                                .padding(.top, 5)
                        }
                        GridRow {
                            Image(systemName: "paintbrush.pointed.fill")
                            Text("Cream")
                            Text("sheltered, comfy, neutral")
                        }
                        .foregroundColor(Default.homeColor)
                        GridRow {
                            Image(systemName: "paintbrush.pointed.fill")
                                .gridColumnAlignment(.leading)
                            Text("Maize")
                                .gridColumnAlignment(.leading)
                            Text("sunny, happy, major")
                                .gridColumnAlignment(.leading)
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "paintbrush.pointed.fill")
                            Text("Blue")
                            Text("cloudy, sad, minor")
                            
                        }
                        .foregroundColor(Default.minorColor)
                        GridRow {
                            Image(systemName: "paintbrush.pointed.fill")
                            Text("Red")
                            Text("windy, diabolical, strange")
                            
                        }
                        .foregroundColor(Default.tritoneColor)
                    }
                    Group { //
                        GridRow {
                            Text("Intervals: Major-Minor and Consonance-Dissonance")
                                .font(.caption)
                                .gridCellUnsizedAxes(.horizontal)
                                .gridCellColumns(3)
                                .padding(.top, 10)
                        }
                        GridRow {
                            Image(systemName: "house")
                            Text("Cream Home")
                            Text("neutral perfect")
                        }
                        .foregroundColor(Default.homeColor)
                        GridRow {
                            Image(systemName: "diamond.fill")
                            Text("Maize Gem")
                            Text("major consonant")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "diamond.fill")
                            Text("Blue Gem")
                            Text("minor consonant")
                        }
                        .foregroundColor(Default.minorColor)
                        GridRow {
                            Image(systemName: "circle.fill")
                            Text("Maize Stone")
                            Text("major dissonant")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "circle.fill")
                            Text("Blue Stone")
                            Text("minor dissonant")
                        }
                        .foregroundColor(Default.minorColor)
                        GridRow {
                            Image(systemName: "circle.fill")
                            Text("Red Stone")
                            Text("strange dissonant")
                        }
                        .foregroundColor(Default.tritoneColor)
                    }
                    Group {
                        GridRow {
                            Text("Chords and Progressions")
                                .font(.caption)
                                .gridCellUnsizedAxes(.horizontal)
                                .gridCellColumns(3)
                                .padding(.top, 10)
                        }
                        GridRow {
                            Image(systemName: "plus.square.fill")
                                .gridColumnAlignment(.leading)
                            Text("Maize Plus")
                                .gridColumnAlignment(.leading)
                            Text("major")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "minus.square.fill")
                            Text("Blue Minus")
                            Text("minor")
                        }
                        .foregroundColor(Default.minorColor)
                        GridRow {
                            Image(systemName: "multiply.square.fill")
                                .gridColumnAlignment(.leading)
                            Text("Maize Multiply")
                                .gridColumnAlignment(.leading)
                            Text("inverted major")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "multiply.square.fill")
                            Text("Blue Multiply")
                            Text("inverted minor")
                                .lineLimit(2)
                        }
                        .foregroundColor(Default.minorColor)
                        GridRow {
                            Image(systemName: "greaterthan.square.fill")
                            Text("Higher")
                            Text("right, upward emphasis")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "lessthan.square.fill")
                            Text("Lower")
                            Text("left, downward emphasis")
                        }
                        .foregroundColor(Default.minorColor)
                    }
                    Divider()
                        .gridCellUnsizedAxes(.horizontal)
                    Group {
                        GridRow {
                            Text("Help")
                                .font(.subheadline)
                                .padding(.bottom, 5)
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
                            Text("The design of [Homey Pad](https://homeymusic.com/products/homeypad) including layout, color palette, user interactions and icon language is released under an [Attribution 4.0 International license (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).")
                            .gridCellColumns(3)
                        }
                        GridRow {
                            (
                                Text("The [Homey Pad](https://homeymusic.com/products/homeypad) software is released under an [MIT License](https://opensource.org/license/mit/) and is available on [GitHub](https://github.com/homeymusic/homeypad).")
                            )
                            .gridCellColumns(3)
                        }
                        GridRow {
                            (
                                Text(Image(systemName: "c.circle")) +
                                Text(" 2023 [Homey Music](https://homeymusic.com), a registered trade name of Ballet, LLC. All other rights reserved. [Homey Pad](https://homeymusic.com/products/homeypad) is a product name and trademark of [Homey Music](https://homeymusic.com).")
                            )
                            .gridCellColumns(3)
                        }
                        GridRow {
                            Text("The Yamaha Disklavier Pro soundfont was produced by [Zenvoid](https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html) from samples made by [Zenph Studios](https://www.nytimes.com/2007/03/12/arts/music/12conn.html) for [One Laptop Per Child](http://wiki.laptop.org/go/Sound_samples) and is used by [Homey Pad](https://homeymusic.com/products/homeypad) under a [Creative Commons Attribution 3.0 license](https://creativecommons.org/licenses/by/3.0/).")
                                .padding(.top, 3)
                                .gridCellColumns(3)
                        }
                    }
                    .font(.footnote)
                }
                .padding([.leading, .trailing], 10)
            }
            .frame(width: 375)
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
