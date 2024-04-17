//
//  HelpView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 4/9/24.
//

import SwiftUI

struct HelpView: View {
    @ObservedObject var viewConductor: ViewConductor
    
    static let icon = "questionmark.circle"
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                withAnimation {
                    viewConductor.showHelp.toggle()
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: viewConductor.showHelp ? HelpView.icon + ".fill" : HelpView.icon)
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .popover(isPresented: $viewConductor.showHelp, content: {
                VStack(spacing: 0) {
                    HelpPopoverView().presentationCompactAdaptation(.popover)
                }
            })
        }
    }
}


