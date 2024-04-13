import SwiftUI

struct Symmetric<Content>: View where Content: View {
    let keyboardKey: (Pitch) -> Content
    var viewConductor: ViewConductor
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(viewConductor.lowMIDI...viewConductor.highMIDI, id: \.self) { midi in
                let majorMinor: MajorMinor = Interval.majorMinor(midi: midi, tonicMIDI: Int(viewConductor.tonicPitch.midi))
                if majorMinor == .minor {
                    VStack(spacing: 0.0)  {
                        if safeMIDI(midi: midi + 1) {
                            KeyContainer(conductor: viewConductor,
                                         pitch: viewConductor.allPitches[midi + 1],
                                         keyboardKey: keyboardKey)
                        } else {
                            Color.clear
                        }
                        if safeMIDI(midi: midi) {
                            KeyContainer(conductor: viewConductor,
                                         pitch: viewConductor.allPitches[midi],
                                         keyboardKey: keyboardKey)
                        } else {
                            Color.clear
                        }
                    }
                } else if majorMinor == .neutral {
                    let intervalClass: IntegerNotation = Interval.intervalClass(midi: midi, tonicMIDI: Int(viewConductor.tonicPitch.midi))
                    if intervalClass == .seven { // perfect fifth takes care of rendering the tritone above it
                        if safeMIDI(midi: midi) {
                            KeyContainer(conductor: viewConductor,
                                         pitch: viewConductor.allPitches[midi],
                                         keyboardKey: keyboardKey)
                            .overlay() { // render tritone as overlay
                                // only render tritone if P4, tt and P5 are safe
                                if safeMIDI(midi: midi - 1) && safeMIDI(midi: midi - 2) {
                                    GeometryReader { proxy in
                                        let ttLength = min(proxy.size.height * 0.3125, proxy.size.width * 1.0)
                                        ZStack {
                                            KeyContainer(conductor: viewConductor,
                                                         pitch: viewConductor.allPitches[midi-1], // tritone
                                                         zIndex: 1,
                                                         keyboardKey: keyboardKey)
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
                        if safeMIDI(midi: midi) {
                            KeyContainer(conductor: viewConductor,
                                         pitch: viewConductor.allPitches[midi],
                                         keyboardKey: keyboardKey)
                        } else {
                            Color.clear
                        }
                    }
                }
            }
        }
        .animation(viewConductor.animationStyle, value: viewConductor.tonicMIDI)
        .clipShape(Rectangle())
    }
    
}

