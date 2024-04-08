import SwiftUI

struct Symmetric<Content>: View where Content: View {
    let content: (Pitch, Pitch) -> Content
    var model: KeyboardModel
    var allPitches: [Pitch]
    var tonicPitch: Pitch
    var lowMIDI: Int
    var highMIDI: Int
    
    func safeMIDI(midi: Int) -> Bool {
        midi >= 0 && midi <= 127
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(lowMIDI...highMIDI, id: \.self) { midi in
                let majorMinor: MajorMinor = Interval.majorMinor(midi: midi, tonicMIDI: Int(tonicPitch.midi))
                if majorMinor == .minor {
                    VStack(spacing: 0.0)  {
                        if safeMIDI(midi: midi + 1) {
                            KeyContainer(model: model,
                                         pitch: allPitches[midi + 1],
                                         tonicPitch: tonicPitch,
                                         content: content)
                        } else {
                            Color.clear
                        }
                        if safeMIDI(midi: midi) {
                            KeyContainer(model: model,
                                         pitch: allPitches[midi],
                                         tonicPitch: tonicPitch,
                                         content: content)
                        } else {
                            Color.clear
                        }
                    }
                } else if majorMinor == .neutral {
                    let intervalClass: IntegerNotation = Interval.intervalClass(midi: midi, tonicMIDI: Int(tonicPitch.midi))
                    if intervalClass == .seven {
                        if safeMIDI(midi: midi) {
                            KeyContainer(model: model,
                                         pitch: allPitches[midi],
                                         tonicPitch: tonicPitch,
                                         content: content)
                            .overlay() {
                                GeometryReader { proxy in
                                    let ttLength = min(proxy.size.height * 0.3125, proxy.size.width * 1.0)
                                    ZStack {
                                        if safeMIDI(midi: midi-1) {
                                            KeyContainer(model: model,
                                                         pitch: allPitches[midi-1],
                                                         tonicPitch: tonicPitch,
                                                         zIndex: 1,
                                                         content: content)
                                            .frame(width: ttLength, height: ttLength)
                                        } else {
                                            Color.clear
                                        }
                                    }
                                    .offset(x: -ttLength / 2.0, y: proxy.size.height / 2.0 - ttLength / 2.0)
                                }
                            }
                        } else {
                            Color.clear
                        }
                        
                    } else if intervalClass != .six {
                        if safeMIDI(midi: midi) {
                            
                            KeyContainer(model: model,
                                         pitch: allPitches[midi],
                                         tonicPitch: tonicPitch,
                                         content: content)
                        } else {
                            Color.clear
                        }
                    }
                }
            }
        }
        .clipShape(Rectangle())
    }
    
}

