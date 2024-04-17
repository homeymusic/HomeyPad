//
//  PitchDirectionPickerView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 4/16/24.
//

import SwiftUI

struct PitchDirectionPickerView: View {
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var tonicConductor: ViewConductor

    var body: some View {
        HStack {
            Picker("", selection: $tonicConductor.pitchDirection) {
                Image(systemName: PitchDirection.downward.icon)
                    .tag(PitchDirection.downward)
                Image(systemName: PitchDirection.upward.icon)
                    .tag(PitchDirection.upward)
            }
            .frame(maxWidth: 90)
            .pickerStyle(.segmented)
        }
    }
}
