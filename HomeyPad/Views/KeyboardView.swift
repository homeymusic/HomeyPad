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
            Keyboard(viewConductor: viewConductor) { pitch in
                KeyboardKey(pitch: pitch,
                            viewConductor: viewConductor)
            }
        case .symmetric:
            Keyboard(viewConductor: viewConductor) { pitch in
                KeyboardKey(pitch: pitch,
                            viewConductor: viewConductor)
            }
        case .piano:
            Keyboard(viewConductor: viewConductor) { pitch in
                KeyboardKey(pitch: pitch,
                            viewConductor: viewConductor)
            }
        case .strings:
            switch viewConductor.stringsLayoutChoice {
            case .guitar:
                Keyboard(viewConductor: viewConductor) { pitch in
                    KeyboardKey(pitch: pitch,
                                viewConductor: viewConductor)
                }
            case .bass:
                Keyboard(viewConductor: viewConductor) { pitch in
                    KeyboardKey(pitch: pitch,
                                viewConductor: viewConductor)
                }
            case .violin:
                Keyboard(viewConductor: viewConductor) { pitch in
                    KeyboardKey(pitch: pitch,
                                viewConductor: viewConductor)
                }
            }
        default:
            Color.clear
        }
    }
}
