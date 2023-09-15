//
//  SettingsView.swift
//
//  Created by Brian McAuliff Mulloy on 9/12/23.
//

import SwiftUI

struct CustomizeView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showClassicalSelector: Bool
    @Binding var showHomeySelector: Bool
    @Binding var octaveCount: Int
    @Binding var keysPerRow: Int
    
    var body: some View {
        VStack {
            Text("Customize")
                .font(.headline)
            Divider()
            Grid {
                GridRow {
                    Image(systemName: "arrow.up.and.line.horizontal.and.arrow.down")
                        .gridCellAnchor(.center)
                    Text("Rows")
                        .gridCellAnchor(.leading)
                    Stepper("", value: $octaveCount,
                            in: 1...6,
                            step: 1)
                    .gridCellAnchor(.trailing)
                }
                GridRow {
                    Image(systemName: "arrow.left.and.line.vertical.and.arrow.right")
                        .gridCellAnchor(.center)
                    Text("Columns")
                        .gridCellAnchor(.leading)
                    Stepper("", value: $keysPerRow,
                            in: 13...37,
                            step: 2)
                    .gridCellAnchor(.trailing)
                }
                Divider()
                Text("Home Note Selector")
                    .font(.subheadline)
                    .padding(.top, 10)
                GridRow {
                    Image(systemName: "music.note")
                        .gridCellAnchor(.center)
                    
                    Text("Classical")
                        .gridCellAnchor(.leading)
                    
                    Toggle("", isOn: $showClassicalSelector)
                        .gridCellAnchor(.trailing)
                }
                GridRow {
                    Image(systemName: "music.note.house")
                        .gridCellAnchor(.center)
                    
                    Text("Homey")
                        .gridCellAnchor(.leading)
                    
                    Toggle("", isOn: $showHomeySelector)
                        .gridCellAnchor(.trailing)
                }
            }
            Divider()
            Button(role: .cancel, action: {
                showClassicalSelector = false
                showHomeySelector = false
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
