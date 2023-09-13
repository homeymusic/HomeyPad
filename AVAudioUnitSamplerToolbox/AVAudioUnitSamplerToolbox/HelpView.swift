//
//  SettingsView.swift
//  AVAudioUnitSamplerToolbox
//
//  Created by Brian McAuliff Mulloy on 9/12/23.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Help")
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
        }
        .padding(10)
    }
}
