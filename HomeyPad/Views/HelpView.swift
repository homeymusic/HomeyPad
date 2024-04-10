//
//  HelpView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 4/9/24.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        HStack {
            Image(systemName: "questionmark.circle")
                .foregroundColor(.white)
                .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
