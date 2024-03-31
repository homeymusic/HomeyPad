//
//  KeyboardView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/30/24.
//

import SwiftUI
import Keyboard

struct KeyboardView: View {
    @StateObject var viewConductor: ViewConductor

    var body: some View {
        switch viewConductor.pad {
        case .isomorphic:
            Keyboard(layout: .isomorphic(pitchRange: viewConductor.pitchRange),
                     noteOn: viewConductor.noteOn, noteOff: viewConductor.noteOff) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     formFactor: .isomorphic,
                                     tonicPitch: viewConductor.tonicPitch)
                     }
        case .symmetric:
            Keyboard(layout: .symmetric(pitchRange: viewConductor.pitchRange),
                     noteOn: viewConductor.noteOn, noteOff: viewConductor.noteOff) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     formFactor: .symmetric,
                                     tonicPitch: viewConductor.tonicPitch)
                     }
        case .symmetricLoud:
            Keyboard(layout: .symmetric(pitchRange: viewConductor.pitchRange),
                     noteOn: viewConductor.noteOn, noteOff: viewConductor.noteOff) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     formFactor: .symmetric,
                                     tonicPitch: viewConductor.tonicPitch,
                                     intervallicKeyColors: IntervalColor.homey,
                                     intervallicSymbolColors: IntervalColor.homey,
                                     subtle: false)
                     }
        case .piano:
            Keyboard(layout: .piano(pitchRange: viewConductor.pitchRange),
                     noteOn: viewConductor.noteOn, noteOff: viewConductor.noteOff) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     formFactor: .piano,
                                     tonicPitch: viewConductor.tonicPitch)
                     }
        case .guitar:
            Keyboard(layout: .guitar(),
                     noteOn: viewConductor.noteOn, noteOff: viewConductor.noteOff) { pitch, isActivated in
                         KeyboardKey(pitch: pitch,
                                     isActivated: isActivated,
                                     formFactor: .guitar,
                                     tonicPitch: viewConductor.tonicPitch)
                     }
        }
    }
}
