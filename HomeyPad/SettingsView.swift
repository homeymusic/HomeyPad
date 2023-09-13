//
//  SettingsView.swift
//
//  Created by Brian McAuliff Mulloy on 9/12/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var tonicSelector: Bool
    @Binding var octaveCount: Int
    @Binding var keysPerRow: Int
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.headline)
            Divider()
            Grid(alignment: .leading) {
                GridRow {
                    Image(systemName: "music.quarternote.3")
                    Text("Notes")
                    Toggle("", isOn: $tonicSelector)
                }
                GridRow {
                    Image(systemName: "arrow.up.and.line.horizontal.and.arrow.down")
                    Text("Rows")
                    Stepper("", value: $octaveCount,
                            in: 1...6,
                            step: 1)
                }
                GridRow {
                    Image(systemName: "arrow.left.and.line.vertical.and.arrow.right")
                    Text("Columns")
                        .padding(.trailing, 30)
                    Stepper("", value: $keysPerRow,
                            in: 13...37,
                            step: 2)
                }
            }
            Divider()
            Button(role: .cancel, action: {
                tonicSelector = false
                octaveCount = 1
                keysPerRow = 13
                dismiss()
            }) {
                Label("Reset", systemImage: "gobackward")
            }
        }
        .padding(10)
    }
}
