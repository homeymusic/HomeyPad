//
//  SelectorStyle.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 9/18/23.
//

import SwiftUI

struct SelectorStyle: View {
    let col: Int
    let showClassicalSelector: Bool
    let showMonthsSelector: Bool
    let showPianoSelector: Bool
    let tonicPitchClass: Int
    
    var body: some View {
        let pitchClass = tonicPitchClass+col
        ZStack {
            Rectangle()
                .cornerRadius(5)
                .foregroundColor(showPianoSelector ? pianoBackgroundColor(pitchClass) : homeyBackgroundColor(col))
            VStack {
                if showClassicalSelector {
                    Text(classicalLabel(pitchClass))
                        .font(.title3)
                }
                if showMonthsSelector {
                    Text(monthLabel(pitchClass))
                        .font(.custom("Monaco", size: 20))
                        .textCase(.uppercase)
                }
            }
            .scaledToFit()
            .lineLimit(1)
            .minimumScaleFactor(0.01)
            .foregroundColor(showPianoSelector ? pianoForegroundColor(pitchClass) : homeyForegroundColor(col))
            .padding(2)
        }
    }
}
