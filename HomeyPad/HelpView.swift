//
//  SettingsView.swift
//
//  Created by Brian McAuliff Mulloy on 9/12/23.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Homey Pad")
                .font(.headline)
            Divider()
            Grid(alignment: .leading, verticalSpacing: 10) {
                GridRow {
                    Image(systemName: "questionmark.video")
                    Link("Videos", destination: URL(string: "https://www.youtube.com/playlist?list=PLT8nHHGqWrpGq7QGQtpFAMaTafpUe8IUI")!)
                }
                GridRow {
                    Image(systemName: "person.crop.circle.badge.questionmark")
                    Link("Forums", destination: URL(string: "https://groups.google.com/a/homeymusic.com/g/homey-pad")!)
                }
                GridRow {
                    Image(systemName: "questionmark.folder")
                    Link("Documentation", destination: URL(string: "https://homeymusic.com/products/homeypad")!)
                }
            }
            Divider()
            ScrollView {
                HStack {
                    (
                        Text(Image(systemName: "c.circle")) +
                        Text(" 2023 [Homey Music](https://homeymusic.com), a trade name of Ballet, LLC. All rights reserved.")
                    )
                }
                Divider()
                HStack {
                    Text("The Yamaha Disklavier Pro soundfont was produced for [One Laptop Per Child](http://wiki.laptop.org/go/Sound_samples), sourced via the [FreePats project](https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html) and is used here under a [Creative Commons Attribution 3.0 license](https://creativecommons.org/licenses/by/3.0/).")
                }
            }
            .font(.footnote)
            .frame(width: 150)
        }
        .padding(10)
    }
}
