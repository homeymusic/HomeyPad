import SwiftUI
import HomeyMusicKit

struct SymmetricView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    var viewConductor: ViewConductor
    @StateObject private var tonalContext = TonalContext.shared

    var body: some View {
        VStack(spacing: 0) {
            ForEach((-viewConductor.layoutRowsCols.rowsPerSide[.symmetric]!...viewConductor.layoutRowsCols.rowsPerSide[.symmetric]!).reversed(), id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(viewConductor.lowMIDI...viewConductor.highMIDI, id: \.self) { col in
                        let unSureMIDI: Int = Int(col) + 12 * row
                        let majorMinor: MajorMinor = Interval.majorMinor(midi: unSureMIDI, tonicMIDI: Int(tonalContext.tonicMIDI))
                        if majorMinor == .minor {
                            VStack(spacing: 0.0)  {
                                if tonalContext.safeMIDI(midi: unSureMIDI + 1) {
                                    KeyboardKeyContainerView(conductor: viewConductor,
                                                             pitch: tonalContext.allPitches[unSureMIDI + 1],
                                                             keyboardKeyView: keyboardKeyView)
                                } else {
                                    Color.clear
                                }
                                if tonalContext.safeMIDI(midi: unSureMIDI) {
                                    KeyboardKeyContainerView(conductor: viewConductor,
                                                             pitch: tonalContext.allPitches[unSureMIDI],
                                                             keyboardKeyView: keyboardKeyView)
                                } else {
                                    Color.clear
                                }
                            }
                        } else if majorMinor == .neutral {
                            let intervalClass: IntegerNotation = Interval.intervalClass(midi: unSureMIDI, tonicMIDI: Int(tonalContext.tonicMIDI))
                            if intervalClass == .seven { // perfect fifth takes care of rendering the tritone above it
                                if tonalContext.safeMIDI(midi: unSureMIDI) {
                                    KeyboardKeyContainerView(conductor: viewConductor,
                                                             pitch: tonalContext.allPitches[unSureMIDI],
                                                             keyboardKeyView: keyboardKeyView)
                                    .overlay() { // render tritone as overlay
                                        // only render tritone if P4, tt and P5 are safe
                                        if tonalContext.safeMIDI(midi: unSureMIDI - 1) && tonalContext.safeMIDI(midi: unSureMIDI - 2) {
                                            GeometryReader { proxy in
                                                let ttLength = viewConductor.tritoneLength(proxySize: proxy.size)
                                                ZStack {
                                                    KeyboardKeyContainerView(conductor: viewConductor,
                                                                             pitch: tonalContext.allPitches[unSureMIDI-1], // tritone
                                                                             zIndex: 1,
                                                                             keyboardKeyView: keyboardKeyView)
                                                    .frame(width: ttLength, height: ttLength)
                                                }
                                                .offset(x: -ttLength / 2.0, y: proxy.size.height / 2.0 - ttLength / 2.0)
                                            }
                                        }
                                    }
                                } else {
                                    Color.clear
                                }
                                
                            } else if intervalClass != .six { // skip tritone
                                if tonalContext.safeMIDI(midi: unSureMIDI) {
                                    KeyboardKeyContainerView(conductor: viewConductor,
                                                             pitch: tonalContext.allPitches[unSureMIDI],
                                                             keyboardKeyView: keyboardKeyView)
                                } else {
                                    Color.clear
                                }
                            }
                        }
                    }
                }
            }
        }
        .animation(viewConductor.animationStyle, value: tonalContext.tonicMIDI)
        .clipShape(Rectangle())
    }
    
}

