//
//  KeyboardLayoutPickerView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/24/24.
//

import SwiftUI
import Keyboard

struct FooterView: View {
    @StateObject var viewConductor: ViewConductor

    var body: some View {
        HStack(spacing: 0) {
            Picker("", selection: $viewConductor.pad) {
                ForEach(Pad.allCases) { pad in
                    Image(systemName: pad.icon)
                        .tag(pad)
                }
            }
            .pickerStyle(.segmented)
            .padding([.leading, .trailing], 300)
        }
    }
}
