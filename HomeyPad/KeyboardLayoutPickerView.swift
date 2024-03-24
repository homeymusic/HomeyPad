//
//  KeyboardLayoutPickerView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/24/24.
//

import SwiftUI
import Keyboard

struct KeyboardLayoutPickerView: View {
    let keyboards: [Keyboard<KeyboardKey>]
    @StateObject var viewConductor: ViewConductor


    var body: some View {
        HStack {
            /// select layout
            Picker("", selection: $viewConductor.keyboardIndex) {
                ForEach(keyboards.indices) { i in
                    keyboards[i].icon
                        .tag(i)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 75)
            .padding(.trailing, 10)
        }
    }
}
