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
                    
//                    Text("Piano")
//                        .gridCellAnchor(.leading)
//                        .lineLimit(1)
//                        .fixedSize()
//                    
//                    Spacer()
//                    
                    Toggle("Piano", isOn: $showPianoSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                Divider()
                GridRow {
                    Image(systemName: "a.square")
                        .gridCellAnchor(.center)
                    
//                    Text("Letters")
//                        .gridCellAnchor(.leading)
//                        .lineLimit(1)
//                        .fixedSize()
//                    Spacer()
                    
                    
                    Toggle("Letters", isOn: $showClassicalSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    Image(systemName: "calendar")
                        .gridCellAnchor(.center)
                    
//                    Text("Months")
//                        .gridCellAnchor(.leading)
//                        .lineLimit(1)
//                        .fixedSize()
//                    
//                    Spacer()
//                    
                    Toggle("Months", isOn: $showMonthsSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                Divider()
                GridRow {
                    Image(systemName: "0.square")
                        .gridCellAnchor(.center)
                    
//                    Text("Numbers")
//                        .gridCellAnchor(.leading)
//                        .lineLimit(1)
//                        .fixedSize()
//                    Spacer()
//                    
//                    
                    Toggle("Numbers", isOn: $showIntegersSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    Image(systemName: "ruler")
                        .gridCellAnchor(.center)
                    
//                    Text("Intervals")
//                        .gridCellAnchor(.leading)
//                        .lineLimit(1)
//                        .fixedSize()
//                    Spacer()
                    Toggle("Intervals", isOn: $showIntervals)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    let enableMovement = showIntervals || showIntegersSelector
//                    Image(systemName: "arrow.left.arrow.right")
//                        .gridCellAnchor(.center)
//                        .foregroundColor(enableMovement ? .white : Default.pianoGray)
//                    Text("Direction")
//                        .gridCellAnchor(.leading)
//                        .lineLimit(1)
//                        .fixedSize()
//                        .foregroundColor(enableMovement ? .white : Default.pianoGray)
//                    Spacer()
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
