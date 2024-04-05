//
//  KeyboardView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/30/24.
//

import SwiftUI

struct KeyboardView: View {
    @StateObject var viewConductor: ViewConductor
    
    var body: some View {
        switch viewConductor.layoutChoice {
        case .isomorphic:
            Keyboard(tonicPitch: viewConductor.tonicPitch, layout: .isomorphic(pitches: viewConductor.pitches, tonicPitch: viewConductor.tonicPitch)) { pitch, tonicPitch in
                KeyboardKey(pitch: pitch,
                            tonicPitch: viewConductor.tonicPitch,
                            layoutChoice: .isomorphic,
                            paletteChoice: viewConductor.paletteChoice[.isomorphic]!,
                            intervalLabels: viewConductor.intervalLabels)
            }
        case .symmetric:
            Keyboard(tonicPitch: viewConductor.tonicPitch, layout: .symmetric(pitches: viewConductor.pitches, tonicPitch: viewConductor.tonicPitch)) { pitch, tonicPitch in
                KeyboardKey(pitch: pitch,
                            tonicPitch: viewConductor.tonicPitch,
                            layoutChoice: .symmetric,
                            paletteChoice: viewConductor.paletteChoice[.symmetric]!,
                            intervalLabels: viewConductor.intervalLabels)
            }
        case .piano:
            Keyboard(tonicPitch: viewConductor.tonicPitch, layout: .piano(pitches: viewConductor.pitches, tonicPitch: viewConductor.tonicPitch)) { pitch, tonicPitch in
                KeyboardKey(pitch: pitch,
                            tonicPitch: viewConductor.tonicPitch,
                            layoutChoice: .piano,
                            paletteChoice: viewConductor.paletteChoice[.piano]!,
                            intervalLabels: viewConductor.intervalLabels)
            }
        case .guitar:
            Keyboard(tonicPitch: viewConductor.tonicPitch, layout: .guitar(allPitches: viewConductor.allPitches, tonicPitch: viewConductor.tonicPitch, openStringsMIDI: [64, 59, 55, 50, 45, 40])) { pitch, tonicPitch in
                KeyboardKey(pitch: pitch,
                            tonicPitch: viewConductor.tonicPitch,
                            layoutChoice: .guitar,
                            paletteChoice: viewConductor.paletteChoice[.guitar]!,
                            intervalLabels: viewConductor.intervalLabels)
            }
        }
    }
}
