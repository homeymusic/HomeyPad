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
                    Spacer()
                    Text("Legend")
                        .font(.subheadline)
                        .padding(.bottom, 5)
                    Spacer()
                }
                HStack {
                    Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
                        GridRow {
                            Image(systemName: "plus.square")
                            Text("Gold")
                            Text("sun, happy, major")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "equal.square")
                            Text("Cream")
                            Text("shelter, comfy, neutral")
                        }
                        .foregroundColor(Default.homeColor)
                        GridRow {
                            Image(systemName: "minus.square")
                            Text("Blue")
                            Text("cloud, sad, minor")
                            
                        }
                        .foregroundColor(Default.minorColor)
                        GridRow {
                            Image(systemName: "multiply.square")
                            Text("Red")
                            Text("wind, strange, tritone")
                            
                        }
                        .foregroundColor(Default.tritoneColor)
                        GridRow {
                            Image(systemName: "house")
                            Text("Home")
                            Text("static, pure, tonic")
                        }
                        .foregroundColor(.white)
                        GridRow {
                            Image(systemName: "diamond")
                            Text("Gem")
                            Text("tottering, rich, consonant")
                        }
                        .foregroundColor(.white)
                        GridRow {
                            Image(systemName: "circle")
                            Text("Stone")
                            Text("rolling, harsh, dissonant")
                        }
                        .foregroundColor(.white)
                        GridRow {
                            Image(systemName: "greaterthan.square")
                            Text("Greater")
                            Text("higher, right, upward")
                        }
                        .foregroundColor(Default.majorColor)
                        GridRow {
                            Image(systemName: "lessthan.square")
                            Text("Less")
                            Text("lower, left, downward")
                        }
                        .foregroundColor(Default.minorColor)

                    }
                }
                Divider()
                HStack {
                    Spacer()
                    Text("Help")
                        .font(.subheadline)
                        .padding(.bottom, 5)
                    Spacer()
                }
                VStack(alignment: .center) {
                    Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
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
                    Spacer()
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
            }
            .frame(width: 300)
            .padding(10)
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
