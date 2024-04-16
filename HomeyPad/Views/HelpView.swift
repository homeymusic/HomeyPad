//
//  HelpView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 4/9/24.
//

import SwiftUI

struct HelpView: View {
    @ObservedObject var tonicConductor: ViewConductor
    
    static let icon = "questionmark.circle"
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    tonicConductor.showHelp.toggle()
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: tonicConductor.showHelp ? HelpView.icon + ".fill" : HelpView.icon)
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
                .padding(30.0)
            }
            .popover(isPresented: $tonicConductor.showHelp, content: {
                VStack(spacing: 0) {
                    HelpPopoverView().presentationCompactAdaptation(.popover)
                }
            })
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        
        
    }
}


