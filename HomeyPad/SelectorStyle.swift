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
    let showIntervals: Bool
    let tonicPitchClass: Int
    
    var body: some View {
        let pitchClass = tonicPitchClass+col
        let fg = showPianoSelector ? pianoBackgroundColor(pitchClass) : homeyBackgroundColor(col)
        ZStack {
            Rectangle()
                .foregroundColor(fg)
                .overlay(
                        Rectangle()
                            .stroke(fg, lineWidth: 3)
                            .brightness(mod(col,12)==0 ? 0.06 : -0.03)
                    )
                .padding(2)
            VStack {
                if showIntervals {
                    Text(intervalLabel(col))
                        .font(.custom("Monaco", size: 20))
                }
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
            .padding(5)
        }
    }
}
