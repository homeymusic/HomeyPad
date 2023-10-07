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
                    
                    Text("Piano")
                        .gridCellAnchor(.leading)
                        .lineLimit(1)
                        .fixedSize()

                    Spacer()
                    
                    
                    Toggle("", isOn: $showPianoSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                Divider()
                GridRow {
                    Image(systemName: "a.square")
                        .gridCellAnchor(.center)
                    
                    Text("Letters")
                        .gridCellAnchor(.leading)
                        .lineLimit(1)
                        .fixedSize()
                    Spacer()
                    
                    
                    Toggle("", isOn: $showClassicalSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    Image(systemName: "calendar")
                        .gridCellAnchor(.center)
                    
                    Text("Months")
                        .gridCellAnchor(.leading)
                        .lineLimit(1)
                        .fixedSize()

                    Spacer()
                    
                    Toggle("", isOn: $showMonthsSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                Divider()
                GridRow {
                    Image(systemName: "0.square")
                        .gridCellAnchor(.center)
                    
                    Text("Numbers")
                        .gridCellAnchor(.leading)
                        .lineLimit(1)
                        .fixedSize()
                    Spacer()
                    
                    
                    Toggle("", isOn: $showIntegersSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    Image(systemName: "ruler")
                        .gridCellAnchor(.center)
                    
                    Text("Intervals")
                        .gridCellAnchor(.leading)
                        .lineLimit(1)
                        .fixedSize()
                    Spacer()
                    Toggle("", isOn: $showIntervals)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    let enableMovement = showIntervals || showIntegersSelector
                    Image(systemName: "arrow.left.arrow.right")
                        .gridCellAnchor(.center)
                        .foregroundColor(enableMovement ? .white : Default.pianoGray)
                    Text("Direction")
                        .gridCellAnchor(.leading)
                        .lineLimit(1)
                        .fixedSize()
                        .foregroundColor(enableMovement ? .white : Default.pianoGray)
                    Spacer()
                    Toggle("", isOn: $upwardPitchMovement)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                        .disabled(!enableMovement)
                        .toggleStyle(PitchDirection())
                }
            }
            .padding([.leading, .trailing], 10)
        }
        .padding(10)
    }
}
