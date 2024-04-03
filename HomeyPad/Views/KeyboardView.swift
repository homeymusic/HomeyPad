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
            Keyboard(layout: .isomorphic(pitches: viewConductor.pitches)) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     layoutChoice: .isomorphic,
                                     tonicPitch: viewConductor.tonicPitch)
                     }
        case .symmetric:
            Keyboard(layout: .symmetric(pitches: viewConductor.pitches)) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     layoutChoice: .symmetric,
                                     tonicPitch: viewConductor.tonicPitch)
                     }
        case .piano:
            Keyboard(layout: .piano(pitches: viewConductor.pitches)) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     layoutChoice: .piano,
                                     tonicPitch: viewConductor.tonicPitch)
                     }
        case .guitar:
            Keyboard(layout: .guitar(allPitches: viewConductor.allPitches, openStringsMIDI: [64, 59, 55, 50, 45, 40])) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     layoutChoice: .guitar,
                                     tonicPitch: viewConductor.tonicPitch)
                     }
        }
    }
}
