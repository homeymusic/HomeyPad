import SwiftUI

struct Symmetric<Content>: View where Content: View {
    let content: (Pitch, Pitch) -> Content
    var model: KeyboardModel
    var allPitches: [Pitch]
    var tonicPitch: Pitch
    var lowMIDI: Int
    var highMIDI: Int

    var body: some View {
        HStack(spacing: 0) {
            let dP5 = allPitches.startIndex
            let dtt = allPitches.index(after: dP5)
            let dP4 = allPitches.index(after: dtt)
            let dm3 = allPitches.index(after: dP4)
            let dM3 = allPitches.index(after: dm3)
            let dm2 = allPitches.index(after: dM3)
            let dM2 = allPitches.index(after: dm2)
            let P1 = allPitches.index(after: dM2)
            let m2 = allPitches.index(after: P1)
            let M2 = allPitches.index(after: m2)
            let m3 = allPitches.index(after: M2)
            let M3 = allPitches.index(after: m3)
            let P4 = allPitches.index(after: M3)
            let tt = allPitches.index(after: P4)
            let P5 = allPitches.index(after: tt)
            let m6 = allPitches.index(after: P5)
            let M6 = allPitches.index(after: m6)
            let m7 = allPitches.index(after: M6)
            let M7 = allPitches.index(after: m7)
            let P8 = allPitches.index(after: M7)
            let m9 = allPitches.index(after: P8)
            let M9 = allPitches.index(after: m9)
            let m10 = allPitches.index(after: M9)
            let M10 = allPitches.index(after: m10)
            let P11 = allPitches.index(after: M10)
            let ttt = allPitches.index(after: P11)
            let P12 = allPitches.index(after: ttt)
            
            // below main
            KeyContainer(model: model,
                         pitch: allPitches[dP5],
                         tonicPitch: tonicPitch,
                         content: content)
            KeyContainer(model: model,
                         pitch: allPitches[dP4],
                         tonicPitch: tonicPitch,
                         content: content)
            .overlay() {
                GeometryReader { proxy in
                    let ttLength = tritoneLength(proxy.size)
                    ZStack {
                        KeyContainer(model: model,
                                     pitch: allPitches[dtt],
                                     tonicPitch: tonicPitch,
                                     zIndex: 1,
                                     content: content)
                        .frame(width: ttLength, height: ttLength)
                    }
                    .offset(x: -ttLength / 2.0, y: proxy.size.height / 2.0 - ttLength / 2.0)
                }
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: allPitches[dM3],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: allPitches[dm3],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: allPitches[dM2],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: allPitches[dm2],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            // main octave
            KeyContainer(model: model,
                         pitch: allPitches[P1],
                         tonicPitch: tonicPitch,
                         content: content)
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: allPitches[M2],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: allPitches[m2],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: allPitches[M3],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: allPitches[m3],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            KeyContainer(model: model,
                         pitch: allPitches[P4],
                         tonicPitch: tonicPitch,
                         content: content)
            KeyContainer(model: model,
                         pitch: allPitches[P5],
                         tonicPitch: tonicPitch,
                         content: content)
            .overlay() {
                GeometryReader { proxy in
                    let ttLength = tritoneLength(proxy.size)
                    ZStack {
                        KeyContainer(model: model,
                                     pitch: allPitches[tt],
                                     tonicPitch: tonicPitch,
                                     zIndex: 1,
                                     content: content)
                        .frame(width: ttLength, height: ttLength)
                    }
                    .offset(x: -ttLength / 2.0, y: proxy.size.height / 2.0 - ttLength / 2.0)
                }
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: allPitches[M6],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: allPitches[m6],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: allPitches[M7],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: allPitches[m7],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            KeyContainer(model: model,
                         pitch: allPitches[P8],
                         tonicPitch: tonicPitch,
                         content: content)
            // above main
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: allPitches[M9],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: allPitches[m9],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: allPitches[M10],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: allPitches[m10],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            KeyContainer(model: model,
                         pitch: allPitches[P11],
                         tonicPitch: tonicPitch,
                         content: content)
            KeyContainer(model: model,
                         pitch: allPitches[P12],
                         tonicPitch: tonicPitch,
                         content: content)
            .overlay() {
                GeometryReader { proxy in
                    let ttLength = tritoneLength(proxy.size)
                    ZStack {
                        KeyContainer(model: model,
                                     pitch: allPitches[ttt],
                                     tonicPitch: tonicPitch,
                                     zIndex: 1,
                                     content: content)
                        .frame(width: ttLength, height: ttLength)
                    }
                    .offset(x: -ttLength / 2.0, y: proxy.size.height / 2.0 - ttLength / 2.0)
                }
            }
            
        }
        .clipShape(Rectangle())
    }
    
    func tritoneLength(_ proxySize: CGSize) -> CGFloat {
        return min(proxySize.height * 0.3125, proxySize.width * 1.0)
    }
    
}
