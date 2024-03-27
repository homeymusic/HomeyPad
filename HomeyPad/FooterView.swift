//
//  KeyboardLayoutPickerView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/24/24.
//

import SwiftUI
import Keyboard

struct FooterView: View {
    let keyboards: [Keyboard<KeyboardKey>]
    @StateObject var viewConductor: ViewConductor


    var body: some View {
        HStack(spacing: 0) {
            /// select layout
            Picker("", selection: $viewConductor.keyboardIndex) {
                ForEach(keyboards.indices) { i in
                    keyboards[i].icon
                        .tag(i)
                }
            }
            .pickerStyle(.segmented)
            .padding([.leading, .trailing], 300)
        }
    }
}
