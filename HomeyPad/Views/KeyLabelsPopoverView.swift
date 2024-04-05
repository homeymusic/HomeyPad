//
//  KeyLabelsPopoverView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 4/5/24.
//

import SwiftUI

struct KeyLabelsPopoverView: View {
    @StateObject var viewConductor: ViewConductor
    
    var body: some View {
        let spacing = 3.0
        VStack(spacing: spacing) {

            VStack(spacing: spacing) {
                ForEach(NoteLabelChoice.allCases, id: \.self) {key in
                    Toggle(key.label,
                           systemImage: key.icon,
                           isOn: viewConductor.noteLabelBinding(for: key))
                    .tint(Color.gray)
                }
            }

            Divider()
            
            VStack(spacing: spacing) {
                ForEach(IntervalLabelChoice.allCases, id: \.self) {key in
                    Toggle(key.label,
                           systemImage: key.icon,
                           isOn: viewConductor.intervalLabelBinding(for: key))
                    .tint(Color.gray)
                    if key == .symbol {Divider()}
                }
            }
        }
        .padding(10)
    }
        
}

