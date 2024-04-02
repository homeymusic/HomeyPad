//
//  HeaderView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/27/24.
//

import SwiftUI

struct HeaderView: View {
    @StateObject var viewConductor: ViewConductor
   
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            TonicPickerView(viewConductor: viewConductor)
        }
    }
}
