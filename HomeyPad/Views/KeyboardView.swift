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
            Keyboard(tonicPitch: viewConductor.tonicPitch, layout: .isomorphic(pitches: viewConductor.pitches, tonicPitch: viewConductor.tonicPitch)) { pitch, tonicPitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     tonicPitch: viewConductor.tonicPitch,
                                     isActivated: isActivated,
                                     layoutChoice: .isomorphic)
                     }
        case .symmetric:
            Keyboard(tonicPitch: viewConductor.tonicPitch, layout: .symmetric(pitches: viewConductor.pitches, tonicPitch: viewConductor.tonicPitch)) { pitch, tonicPitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     tonicPitch: viewConductor.tonicPitch,
                                     isActivated: isActivated,
                                     layoutChoice: .symmetric)
                     }
        case .piano:
            Keyboard(tonicPitch: viewConductor.tonicPitch, layout: .piano(pitches: viewConductor.pitches, tonicPitch: viewConductor.tonicPitch)) { pitch, tonicPitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     tonicPitch: viewConductor.tonicPitch,
                                     isActivated: isActivated,
                                     layoutChoice: .piano)
                     }
        case .guitar:
            Keyboard(tonicPitch: viewConductor.tonicPitch, layout: .guitar(allPitches: viewConductor.allPitches, tonicPitch: viewConductor.tonicPitch, openStringsMIDI: [64, 59, 55, 50, 45, 40])) { pitch, tonicPitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     tonicPitch: viewConductor.tonicPitch,
                                     isActivated: isActivated,
                                     layoutChoice: .guitar)
                     }
        }
    }
}
