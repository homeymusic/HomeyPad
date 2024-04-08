// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

struct Piano<Content>: View where Content: View {
    let content: (Pitch, Pitch) -> Content
    let keyboard: KeyboardModel
    var tonicPitch: Pitch
    let spacer: PianoSpacer
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                HStack(spacing: 0) {
                    ForEach(spacer.whiteMIDI, id: \.self) { midi in
                        if midi < 0 || midi > 127 {
                            Color.clear
                                .frame(width: spacer.whiteKeyWidth(geo.size.width))
                        } else {
                            KeyContainer(model: keyboard, pitch: spacer.allPitches[midi], tonicPitch: tonicPitch, content: content)
                                .frame(width: spacer.whiteKeyWidth(geo.size.width))
                        }
                    }
                }
                
                // Black keys.
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Rectangle().opacity(0)
                            .frame(width: spacer.initialSpacerWidth(geo.size.width))
                        if spacer.lowMIDI != spacer.midiBoundedByNaturals.first! {
                            Rectangle().opacity(0).frame(width: spacer.lowerBoundSpacerWidth(geo.size.width))
                        }
                        ForEach(spacer.midiBoundedByNaturals, id: \.self) { midi in
                            if Pitch.accidental(midi: midi) {
                                ZStack {
                                    if midi < 0 || midi > 127 {
                                        Color.clear
                                    } else {
                                        KeyContainer(model: keyboard,
                                                     pitch: spacer.allPitches[midi],
                                                     tonicPitch: tonicPitch,
                                                     zIndex: 1,
                                                     content: content)
                                    }
                                }
                                .frame(width: spacer.blackKeyWidth(geo.size.width))
                            } else {
                                Rectangle().opacity(0)
                                    .frame(width: spacer.blackKeySpacerWidth(geo.size.width, midi: midi))
                            }
                        }
                    }
                    Spacer().frame(height: geo.size.height * (1 - spacer.relativeBlackKeyHeight))
                }
            }
        }
        .clipShape(Rectangle())
    }
}
