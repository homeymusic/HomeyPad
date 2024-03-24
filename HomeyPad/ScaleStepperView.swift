//
//  ScaleStepperView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/24/24.
//

import SwiftUI

struct ScaleStepperView: View {
    @StateObject var viewConductor: ViewConductor

    var body: some View {
        Stepper("Scale: \(viewConductor.scale.description)",
                onIncrement: { viewConductor.scaleIndex += 1 },
                onDecrement: { viewConductor.scaleIndex -= 1 })
    }
}
