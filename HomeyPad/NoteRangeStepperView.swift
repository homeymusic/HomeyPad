//
//  NoteRangeStepperView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/24/24.
//

import SwiftUI
import Tonic

struct NoteRangeStepperView: View {
    @StateObject var viewConductor: ViewConductor

    var body: some View {
        HStack {
            Stepper("Lowest Note: \(Pitch(intValue: viewConductor.lowNote).note(in: .C).description)",
                    onIncrement: {
                        if viewConductor.lowNote < 126, viewConductor.highNote > viewConductor.lowNote + 12 {
                            viewConductor.lowNote += 1
                        }
                    },
                    onDecrement: {
                        if viewConductor.lowNote > 0 {
                            viewConductor.lowNote -= 1
                        }
                    })
            Stepper("Highest Note: \(Pitch(intValue: viewConductor.highNote).note(in: .C).description)",
                    onIncrement: {
                        if viewConductor.highNote < 126 {
                            viewConductor.highNote += 1
                        }
                    },
                    onDecrement: {
                        if viewConductor.highNote > 1, viewConductor.highNote > viewConductor.lowNote + 12 {
                            viewConductor.highNote -= 1
                        }

                    })
        }
    }
}
