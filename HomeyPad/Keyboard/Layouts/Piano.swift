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
                    ForEach(spacer.whiteKeys, id: \.self) { pitch in
                        KeyContainer(model: keyboard, pitch: pitch, tonicPitch: tonicPitch, content: content)
                            .frame(width: spacer.whiteKeyWidth(geo.size.width))
                    }
                }

                // Black keys.
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Rectangle().opacity(0)
                            .frame(width: spacer.initialSpacerWidth(geo.size.width))
                        if spacer.allPitches.first != spacer.pitchesBoundedByNaturals.first {
                            Rectangle().opacity(0).frame(width: spacer.lowerBoundSpacerWidth(geo.size.width))
                        }
                        ForEach(spacer.allPitches, id: \.self) { pitch in
                            if pitch.accidental {
                                ZStack {
                                    KeyContainer(model: keyboard,
                                                 pitch: pitch,
                                                 tonicPitch: tonicPitch,
                                                 zIndex: 1,
                                                 content: content)
                                }
                                .frame(width: spacer.blackKeyWidth(geo.size.width))
                            } else {
                                Rectangle().opacity(0)
                                    .frame(width: spacer.blackKeySpacerWidth(geo.size.width, pitch: pitch))
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
