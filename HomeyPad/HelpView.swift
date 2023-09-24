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
                HStack {
                    Grid(alignment: .leading, horizontalSpacing: 1, verticalSpacing: 5) {
                        Group {
                            HStack {
                                Text("Legend")
                                    .font(.subheadline)
                                    .padding(.bottom, 2)
                                Spacer()
                            }
                            HStack {
                                Text("Colors")
                                    .font(.caption)
                                Spacer()
                            }
                            GridRow {
                                Image(systemName: "plus.square.fill")
                                    .gridColumnAlignment(.leading)
                                Text("Maize")
                                Text("sun, happy, major")
                            }
                            .foregroundColor(Default.majorColor)
                            GridRow {
                                Image(systemName: "minus.square.fill")
                                    .gridColumnAlignment(.leading)
                                Text("Blue")
                                Text("cloud, sad, minor")
                                
                            }
                            .foregroundColor(Default.minorColor)
                            GridRow {
                                Image(systemName: "multiply.square.fill")
                                    .gridColumnAlignment(.leading)
                                Text("Red")
                                Text("wind, diabolical, tritone")
                                
                            }
                            .foregroundColor(Default.tritoneColor)
                            GridRow {
                                Image(systemName: "equal.square.fill")
                                    .gridColumnAlignment(.leading)
                                Text("Cream")
                                Text("shelter, comfy, neutral")
                            }
                            .foregroundColor(Default.homeColor)
                        }
                        Group {
                            HStack {
                                Text("Icons")
                                    .font(.caption)
                                Spacer()
                            }
                            GridRow {
                                Image(systemName: "house.fill")
                                    .gridColumnAlignment(.leading)
                                Text("Home")
                                Text("stable, pure, tonic")
                            }
                            .foregroundColor(.white)
                            GridRow {
                                Image(systemName: "diamond.fill")
                                    .gridColumnAlignment(.leading)
                                Text("Gem")
                                Text("tottering, rich, consonant")
                            }
                            .foregroundColor(.white)
                            GridRow {
                                Image(systemName: "circle.fill")
                                    .gridColumnAlignment(.leading)
                                Text("Stone")
                                Text("rolling, harsh, dissonant")
                            }
                            .foregroundColor(.white)
                        }
                        Group {
                            HStack {
                                Text("Directions")
                                    .font(.caption)
                                Spacer()
                            }
                            GridRow {
                                Image(systemName: "greaterthan.square.fill")
                                    .gridColumnAlignment(.leading)
                                Text("Higher")
                                Text("right, up")
                            }
                            .foregroundColor(Default.majorColor)
                            GridRow {
                                Image(systemName: "lessthan.square.fill")
                                    .gridColumnAlignment(.leading)
                                Text("Lower")
                                Text("left, down")
                            }
                            .foregroundColor(Default.minorColor)
                        }
                        Divider()
                        Group {
                            HStack {
                                Text("Help")
                                    .font(.subheadline)
                                    .padding(.bottom, 5)
                                Spacer()
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
                    }
                }
                Divider()
                VStack(alignment: .leading) {
                    (
                        Text(Image(systemName: "c.circle")) +
                        Text(" 2023 [Homey Music](https://homeymusic.com), a registered trade name of Ballet, LLC. All rights reserved. [Homey Pad](https://homeymusic.com/products/homeypad) is a product name and trademark of [Homey Music](https://homeymusic.com).")
                    )
                    Divider()
                    Text("The Yamaha Disklavier Pro soundfont was produced by [Zenvoid](https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html) from samples made by [Zenph Studios](https://www.nytimes.com/2007/03/12/arts/music/12conn.html) for [One Laptop Per Child](http://wiki.laptop.org/go/Sound_samples) and is used by [Homey Pad](https://homeymusic.com/products/homeypad) under a [Creative Commons Attribution 3.0 license](https://creativecommons.org/licenses/by/3.0/).")
                    Spacer()
                }
                .font(.footnote)
                .padding()
            } // ScrollView
            .frame(width: 325)
            .padding(.leading, 10)
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
