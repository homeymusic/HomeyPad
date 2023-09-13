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
            Image("AppIcon100")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            HStack {
                (
                    Text(Image(systemName: "c.circle")) +
                    Text(" 2023 Homey Music, a trade name of Ballet, LLC. All rights reserved.")
                )
                .font(.footnote)
            }
            .frame(width: 150)
        }
        .padding(10)
    }
}
