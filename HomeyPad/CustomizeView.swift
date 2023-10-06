//
//  SettingsView.swift
//
//  Created by Brian McAuliff Mulloy on 9/12/23.
//

import SwiftUI

struct CustomizeView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showClassicalSelector: Bool
    @Binding var showMonthsSelector: Bool
    @Binding var showPianoSelector: Bool
    @Binding var showIntervals: Bool
    @Binding var octaveCount: Int
    @Binding var keysPerRow: Int
    var midiPlayer: MIDIPlayer
    var viewConductor: ViewConductor
    
    var body: some View {
        VStack {
            Grid {
                GridRow {
                    Image(systemName: "character")
                        .gridCellAnchor(.center)
                    
                    Text("Letters")
                        .gridCellAnchor(.leading)
                    Spacer()
                    
                    
                    Toggle("", isOn: $showClassicalSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    Image(systemName: "ruler")
                        .gridCellAnchor(.center)
                    
                    Text("Intervals")
                        .gridCellAnchor(.leading)
                    Spacer()
                    Toggle("", isOn: $showIntervals)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    Image(systemName: "calendar")
                        .gridCellAnchor(.center)
                    
                    Text("Months")
                        .gridCellAnchor(.leading)
                    
                    Spacer()
                    
                    Toggle("", isOn: $showMonthsSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
                GridRow {
                    Image(systemName: "pianokeys")
                        .gridCellAnchor(.center)
                    
                    Text("Piano")
                        .gridCellAnchor(.leading)
                    Spacer()
                    
                    
                    Toggle("", isOn: $showPianoSelector)
                        .gridCellAnchor(.trailing)
                        .tint(Default.pianoGray)
                }
            }
            .padding([.leading, .trailing], 10)
        }
        .padding(10)
    }
}
