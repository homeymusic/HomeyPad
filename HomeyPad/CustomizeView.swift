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
    @Binding var showPianoSelector: Bool
    @Binding var showIntervals: Bool
    @Binding var octaveCount: Int
    @Binding var keysPerRow: Int
    
    var body: some View {
        VStack {
            Text("Customize")
                .font(.headline)
            Divider()
            ScrollView {
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
                    Text("Home Selector")
                        .font(.subheadline)
                        .padding(.top, 5)
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
                    GridRow {
                        Image(systemName: "pianokeys")
                            .gridCellAnchor(.center)
                        
                        Text("Piano")
                            .gridCellAnchor(.leading)
                        
                        Toggle("", isOn: $showPianoSelector)
                            .gridCellAnchor(.trailing)
                    }
                    //                    TODO: still need to figure out intervals, keys do not know row or column they live in
                    //                    Divider()
                    //                    GridRow {
                    //                        Image(systemName: "ruler")
                    //                            .gridCellAnchor(.center)
                    //
                    //                        Text("Intervals")
                    //                            .gridCellAnchor(.leading)
                    //
                    //                        Toggle("", isOn: $showIntervals)
                    //                            .gridCellAnchor(.trailing)
                    //                    }
                }
                .padding([.leading, .trailing], 10)
            }
            Divider()
            Button(role: .cancel, action: {
                showClassicalSelector = false
                showHomeySelector = false
                showPianoSelector = false
                showIntervals = false
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
