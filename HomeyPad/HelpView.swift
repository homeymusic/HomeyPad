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
                            Text("perfect")
                        }
                        .foregroundColor(.white)
                        GridRow {
                            Image(systemName: "diamond.fill")
                            Text("consonant")
                        }
                        .foregroundColor(.white)
                        GridRow {
                            Image(systemName: "circle.fill")
                            Text("dissonant")
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
                            Text("neutral")
                        }
                        .foregroundColor(Default.homeColor)
                        GridRow {
                            Image(systemName: "paintbrush.pointed.fill")
                            Text("major")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "paintbrush.pointed.fill")
                            Text("minor")
                        }
                        .foregroundColor(Default.minorColor)
                        GridRow {
                            Image(systemName: "paintbrush.pointed.fill")
                            Text("tritone")
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
                            Text("perfect")
                        }
                        .foregroundColor(Default.homeColor)
                        GridRow {
                            Image(systemName: "diamond.fill")
                            Text("major consonant")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "diamond.fill")
                            Text("minor consonant")
                        }
                        .foregroundColor(Default.minorColor)
                        GridRow {
                            Image(systemName: "circle.fill")
                            Text("major dissonant")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "circle.fill")
                            Text("minor dissonant")
                        }
                        .foregroundColor(Default.minorColor)
                        GridRow {
                            Image(systemName: "circle.fill")
                            Text("tritone dissonant")
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
                            Image(systemName: "multiply.square.fill")
                            Text("inverted major chord")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "minus.square.fill")
                            Text("minor chord")
                        }
                        .foregroundColor(Default.minorColor)
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
                            Text("Pitch Movement")
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
                                Text(" 2023 [Homey Music](https://homeymusic.com), a registered trade name of Ballet, LLC. All other rights reserved. Homey Pad is a product name and trademark of [Homey Music](https://homeymusic.com).")
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
