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
            HStack {
                Spacer()
                Text("Homey Pad")
                    .font(.headline)
                Spacer()
            }
//            Divider()
//            HStack {
//                Grid(alignment: .leading, verticalSpacing: 10) {
//                    GridRow {
//                        Image(systemName: "questionmark.video")
//                        Link("Videos", destination: URL(string: "https://homeymusic.com/products/homeypad/videos")!)
//                    }
//                    GridRow {
//                        Image(systemName: "person.crop.circle.badge.questionmark")
//                        Link("Forums", destination: URL(string: "https://homeymusic.com/products/homeypad/forums")!)
//                    }
//                    GridRow {
//                        Image(systemName: "questionmark.folder")
//                        Link("Guides", destination: URL(string: "https://homeymusic.com/products/homeypad/guides")!)
//                    }
//                }
//            }
            Divider()
            ScrollView {
                VStack(alignment: .leading) {
                    (
                        Text(Image(systemName: "c.circle")) +
                        Text(" 2023 [Homey Music](https://homeymusic.com), a registered trade name of Ballet, LLC. All rights reserved.")
                    )
                    Divider()
                    Text("The Yamaha Disklavier Pro soundfont was produced by [Zenvoid](https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html) from samples made by [Zenph Studios](https://www.nytimes.com/2007/03/12/arts/music/12conn.html) for [One Laptop Per Child](http://wiki.laptop.org/go/Sound_samples) and is used by [Homey Pad](https://homeymusic.com/products/homeypad) under a [Creative Commons Attribution 3.0 license](https://creativecommons.org/licenses/by/3.0/).")
                    Spacer()
                }
            }
            .font(.footnote)
        }
        .frame(width: 300)
        .padding(10)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
