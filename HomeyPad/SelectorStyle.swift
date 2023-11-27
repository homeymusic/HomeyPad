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
    let showIntegersSelector: Bool
    let showRomanSelector: Bool
    let showDegreeSelector: Bool
    let showMonthsSelector: Bool
    let showPianoSelector: Bool
    let showIntervals: Bool
    let tonicPitchClass: Int
    let upwardPitchMovement: Bool
    
    var body: some View {
        let pitchClass = tonicPitchClass+col
        let fg = showPianoSelector ? pianoBackgroundColor(pitchClass) : homeyBackgroundColor(col)
        let octaveAdjustment = upwardPitchMovement ? 0 : -12
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
                if showClassicalSelector {
                    Text(classicalLabel(pitchClass))
                        .font(.title3)
                }
                if showMonthsSelector {
                    Text(monthLabel(pitchClass))
                        .font(.custom("Courier", size: 20))
                        .textCase(.uppercase)
                }
                if showIntegersSelector {
                    let value: Int = col + octaveAdjustment
                    let prefix = value < 0 || (value == 0 && !upwardPitchMovement) ? "<" : ""
                    Text("\(prefix)\(String(abs(value)))")
                        .font(.custom("Courier", size: 20))
                }
                if showRomanSelector {
                    Text(romanLabel(pitchClass: col, upwardPitchMovement: upwardPitchMovement))
                        .font(.custom("Courier", size: 20))
                }
                if showDegreeSelector {
                    Text(degreeLabel(pitchClass: col, upwardPitchMovement: upwardPitchMovement))
                        .font(.custom("Courier", size: 20))
                }
                if showIntervals {
                    Text(intervalLabel(col + octaveAdjustment, upwardPitchMovement: upwardPitchMovement))
                        .font(.custom("Courier", size: 20))
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
