import SwiftUI

struct Symmetric<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    var model: KeyboardModel
    var pitchRange: ClosedRange<Pitch>
    
    var body: some View {
        HStack(spacing: 0) {
            let dP5 = pitchRange.startIndex
            let dtt = pitchRange.index(after: dP5)
            let dP4 = pitchRange.index(after: dtt)
            let dm3 = pitchRange.index(after: dP4)
            let dM3 = pitchRange.index(after: dm3)
            let dm2 = pitchRange.index(after: dM3)
            let dM2 = pitchRange.index(after: dm2)
            let P1 = pitchRange.index(after: dM2)
            let m2 = pitchRange.index(after: P1)
            let M2 = pitchRange.index(after: m2)
            let m3 = pitchRange.index(after: M2)
            let M3 = pitchRange.index(after: m3)
            let P4 = pitchRange.index(after: M3)
            let tt = pitchRange.index(after: P4)
            let P5 = pitchRange.index(after: tt)
            let m6 = pitchRange.index(after: P5)
            let M6 = pitchRange.index(after: m6)
            let m7 = pitchRange.index(after: M6)
            let M7 = pitchRange.index(after: m7)
            let P8 = pitchRange.index(after: M7)
            let m9 = pitchRange.index(after: P8)
            let M9 = pitchRange.index(after: m9)
            let m10 = pitchRange.index(after: M9)
            let M10 = pitchRange.index(after: m10)
            let P11 = pitchRange.index(after: M10)
            let ttt = pitchRange.index(after: P11)
            let P12 = pitchRange.index(after: ttt)
            
            // below main
            KeyContainer(model: model,
                         pitch: pitchRange[dP5],
                         content: content)
            KeyContainer(model: model,
                         pitch: pitchRange[dP4],
                         content: content)
            .overlay() {
                GeometryReader { proxy in
                    let ttLength = tritoneLength(proxy.size)
                    ZStack {
                        KeyContainer(model: model,
                                     pitch: pitchRange[dtt],
                                     zIndex: 1,
                                     content: content)
                        .frame(width: ttLength, height: ttLength)
                    }
                    .offset(x: -ttLength / 2.0, y: proxy.size.height / 2.0 - ttLength / 2.0)
                }
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitchRange[dM3],
                             content: content)
                KeyContainer(model: model,
                             pitch: pitchRange[dm3],
                             content: content)
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitchRange[dM2],
                             content: content)
                KeyContainer(model: model,
                             pitch: pitchRange[dm2],
                             content: content)
            }
            // main octave
            KeyContainer(model: model,
                         pitch: pitchRange[P1],
                         content: content)
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitchRange[M2],
                             content: content)
                KeyContainer(model: model,
                             pitch: pitchRange[m2],
                             content: content)
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitchRange[M3],
                             content: content)
                KeyContainer(model: model,
                             pitch: pitchRange[m3],
                             content: content)
            }
            KeyContainer(model: model,
                         pitch: pitchRange[P4],
                         content: content)
            KeyContainer(model: model,
                         pitch: pitchRange[P5],
                         content: content)
            .overlay() {
                GeometryReader { proxy in
                    let ttLength = tritoneLength(proxy.size)
                    ZStack {
                        KeyContainer(model: model,
                                     pitch: pitchRange[tt],
                                     zIndex: 1,
                                     content: content)
                        .frame(width: ttLength, height: ttLength)
                    }
                    .offset(x: -ttLength / 2.0, y: proxy.size.height / 2.0 - ttLength / 2.0)
                }
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitchRange[M6],
                             content: content)
                KeyContainer(model: model,
                             pitch: pitchRange[m6],
                             content: content)
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitchRange[M7],
                             content: content)
                KeyContainer(model: model,
                             pitch: pitchRange[m7],
                             content: content)
            }
            KeyContainer(model: model,
                         pitch: pitchRange[P8],
                         content: content)
            // above main
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitchRange[M9],
                             content: content)
                KeyContainer(model: model,
                             pitch: pitchRange[m9],
                             content: content)
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitchRange[M10],
                             content: content)
                KeyContainer(model: model,
                             pitch: pitchRange[m10],
                             content: content)
            }
            KeyContainer(model: model,
                         pitch: pitchRange[P11],
                         content: content)
            KeyContainer(model: model,
                         pitch: pitchRange[P12],
                         content: content)
            .overlay() {
                GeometryReader { proxy in
                    let ttLength = tritoneLength(proxy.size)
                    ZStack {
                        KeyContainer(model: model,
                                     pitch: pitchRange[ttt],
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
