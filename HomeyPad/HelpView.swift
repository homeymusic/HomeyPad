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
                Grid(alignment: .leading, horizontalSpacing: 2, verticalSpacing: 5) {
                    Group {
                        GridRow {
                            Text("Legend")
                                .font(.subheadline)
                                .padding(.bottom, 2)
                                .gridCellUnsizedAxes(.horizontal)
                                .gridCellColumns(3)
                        }
                        GridRow {
                            Text("Colors")
                                .font(.caption)
                                .gridCellUnsizedAxes(.horizontal)
                                .gridCellColumns(3)
                        }
                        GridRow {
                            Image(systemName: "plus.square.fill")
                                .gridColumnAlignment(.leading)
                            Text("Maize")
                                .gridColumnAlignment(.leading)
                            Text("sun, happy, major")
                                .gridColumnAlignment(.leading)
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "minus.square.fill")
                            Text("Blue")
                            Text("cloud, sad, minor")
                            
                        }
                        .foregroundColor(Default.minorColor)
                        GridRow {
                            Image(systemName: "multiply.square.fill")
                            Text("Red")
                            Text("wind, diabolical, tritone")
                            
                        }
                        .foregroundColor(Default.tritoneColor)
                        GridRow {
                            Image(systemName: "equal.square.fill")
                            Text("Cream")
                            Text("shelter, comfy, neutral")
                        }
                        .foregroundColor(Default.homeColor)
                    }
                    Group {
                        GridRow {
                            Text("Icons")
                                .font(.caption)
                                .gridCellUnsizedAxes(.horizontal)
                                .gridCellColumns(3)

                        }
                        GridRow {
                            Image(systemName: "house.fill")
                            Text("Home")
                            Text("stable, pure, tonic")
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
                    Group {
                        GridRow {
                            Text("Directions")
                                .font(.caption)
                                .gridCellUnsizedAxes(.horizontal)
                                .gridCellColumns(3)
                        }
                        GridRow {
                            Image(systemName: "greaterthan.square.fill")
                            Text("Higher")
                            Text("right, up")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "lessthan.square.fill")
                            Text("Lower")
                            Text("left, down")
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
                }
                .padding([.leading, .trailing], 10)
                Divider()
                Group {
                    VStack(alignment: .leading) {
                        (
                            Text(Image(systemName: "c.circle")) +
                            Text(" 2023 [Homey Music](https://homeymusic.com), a registered trade name of Ballet, LLC. All rights reserved. [Homey Pad](https://homeymusic.com/products/homeypad) is a product name and trademark of [Homey Music](https://homeymusic.com).")
                        )
                        .padding(.top, 3)
                        Divider()
                        Text("The Yamaha Disklavier Pro soundfont was produced by [Zenvoid](https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html) from samples made by [Zenph Studios](https://www.nytimes.com/2007/03/12/arts/music/12conn.html) for [One Laptop Per Child](http://wiki.laptop.org/go/Sound_samples) and is used by [Homey Pad](https://homeymusic.com/products/homeypad) under a [Creative Commons Attribution 3.0 license](https://creativecommons.org/licenses/by/3.0/).")
                            .padding(.top, 3)
                        
                        Spacer()
                    }
                    .font(.footnote)
                    .padding([.leading, .trailing], 10)
                }
            }
        }
        .frame(width: 300)
    }
}


struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
