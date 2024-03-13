//
//  SettingsView.swift
//
//  Created by Brian McAuliff Mulloy on 9/12/23.
//

import SwiftUI

struct PitchDirection: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        // Insert custom View code here.
    }
    
}
struct CustomizeView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showClassicalSelector: Bool
    @Binding var showIntegersSelector: Bool
    @Binding var showRomanSelector: Bool
    @Binding var showDegreeSelector: Bool
    @Binding var showMonthsSelector: Bool
    @Binding var showPianoSelector: Bool
    @Binding var showIntervals: Bool
    @Binding var linearLayoutOctaveCount: Int
    @Binding var linearLayoutKeysPerRow: Int
    @Binding var gridLayoutOctaveCount: Int
    @Binding var gridLayoutKeysPerRow: Int
    @Binding var upwardPitchMovement: Bool
    var midiPlayer: MIDIPlayer
    var viewConductor: ViewConductor
    
    var body: some View {
        VStack {
            Grid {
                GridRow {
                    Image(systemName: "pianokeys")
                        .gridCellAnchor(.center)
                    Toggle("Piano", isOn: $showPianoSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                Divider()
                GridRow {
                    Image(systemName: "c.square")
                        .gridCellAnchor(.center)
                    Toggle("Letter", isOn: $showClassicalSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    Image(systemName: "calendar")
                        .gridCellAnchor(.center)
                    Toggle("Month", isOn: $showMonthsSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                Divider()
                GridRow {
                    Image(systemName: "ruler")
                        .gridCellAnchor(.center)
                    
                    Toggle("Interval", isOn: $showIntervals)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    Image(systemName: "building.columns.fill")
                        .gridCellAnchor(.center)
                    
                    Toggle("Roman", isOn: $showRomanSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    Image(systemName: "chevron.up")
                        .gridCellAnchor(.center)
                    
                    Toggle("Degree", isOn: $showDegreeSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    Image(systemName: "0.square")
                        .gridCellAnchor(.center)
                    
                    Toggle("Integer", isOn: $showIntegersSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    Picker("", selection: $upwardPitchMovement) {
                        Image(systemName: "lessthan.square.fill")
                            .tag(false)
                        Image(systemName: "greaterthan.square.fill")
                            .tag(true)
                    }
                    .pickerStyle(.segmented)
                    .disabled(!viewConductor.pitchMovementShowing())
                    .gridCellColumns(2)
                }
            }
            .padding([.leading, .trailing], 10)
        }
        .padding(10)
    }
}
