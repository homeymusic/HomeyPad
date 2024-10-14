import SwiftUI
import HomeyMusicKit

struct StringsView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor

    let fretCount: Int = 22
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< viewConductor.openStringsMIDI.count, id: \.self) { string in
                HStack(spacing: 0) {
                    ForEach(0 ..< fretCount + 1, id: \.self) { fret in
                        if (viewConductor.stringsLayoutChoice == .banjo && string == 4 && fret < 5) {
                            Color.clear
                        } else {
                            let midi = viewConductor.openStringsMIDI[string] + fret
                            let pitch = viewConductor.allPitches[midi]
                            KeyboardKeyContainerView(conductor: viewConductor,
                                         pitch: pitch,
                                         keyboardKey: keyboardKeyView)
                        }
                    }
                }
            }
        }
        .animation(viewConductor.animationStyle, value: viewConductor.tonicMIDI)
        .clipShape(Rectangle())
    }
}
