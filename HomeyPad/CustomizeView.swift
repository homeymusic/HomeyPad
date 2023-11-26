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
    @Binding var showMonthsSelector: Bool
    @Binding var showPianoSelector: Bool
    @Binding var showIntervals: Bool
    @Binding var octaveCount: Int
    @Binding var keysPerRow: Int
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
                    Image(systemName: "a.square")
                        .gridCellAnchor(.center)
                    Toggle("Letters", isOn: $showClassicalSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    Image(systemName: "calendar")
                        .gridCellAnchor(.center)
                    Toggle("Months", isOn: $showMonthsSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                Divider()
                GridRow {
                    Image(systemName: "0.square")
                        .gridCellAnchor(.center)
                    
                    Toggle("Numbers", isOn: $showIntegersSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    Image(systemName: "ruler")
                        .gridCellAnchor(.center)
                    
                    Toggle("Intervals", isOn: $showIntervals)
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
                    let enableMovement = showIntervals || showIntegersSelector || showRomanSelector
                    Picker("", selection: $upwardPitchMovement) {
                        Image(systemName: "lessthan.square.fill")
                            .foregroundColor(Default.minorColor)
                            .accentColor(Default.minorColor)
                            .colorMultiply(Default.minorColor)
                            .tag(false)
                        Image(systemName: "greaterthan.square.fill")
                            .foregroundColor(Default.majorColor)
                            .accentColor(Default.majorColor)
                            .colorMultiply(Default.majorColor)
                            .tag(true)
                    }
                    .pickerStyle(.segmented)
                    .disabled(!enableMovement)
                    .gridCellColumns(2)
                }
            }
            .padding([.leading, .trailing], 10)
        }
        .padding(10)
    }
}
