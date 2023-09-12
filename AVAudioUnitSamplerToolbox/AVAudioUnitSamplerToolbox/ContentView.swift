import SwiftUI
import AVFoundation
import Keyboard
import Tonic
import Controls

struct ContentView: View {
    @StateObject var viewConductor = ViewConductor()
    @Environment(\.scenePhase) var scenePhase
    
    @State private var value = 0
    let colors: [Color] = [.orange, .red, .gray, .blue,
                           .green, .purple, .pink]
    
    
    func incrementStep() {
        value += 1
        if value >= colors.count { value = 0 }
    }
    
    
    func decrementStep() {
        value -= 1
        if value < 0 { value = colors.count - 1 }
    }
    
    
    var body: some View {
        
        
        GeometryReader { proxy in
            
            let keysPerRow: Int = (proxy.size.width > 800) ? 25 : 13
            
            ZStack {
                Color.black
                VStack(alignment: .trailing, spacing: 0) {
                    Menu {
                        Toggle(isOn: $viewConductor.tonicSelector) {
                            Text("Home Selector")
                        }
                        Button("1") {
                            viewConductor.octaveCount = 1
                        }
                        Button("2") {
                            viewConductor.octaveCount = 2
                        }
                        Button("3") {
                            viewConductor.octaveCount = 3
                        }
                        Button("5") {
                            viewConductor.octaveCount = 5
                        }
                        Button("8") {
                            viewConductor.octaveCount = 8
                        }
                    } label: {
                        Image(systemName: "gear").foregroundColor(.white)
                    }
                    .padding([.top, .trailing, .bottom], 10)
                    Spacer()
                    if (viewConductor.tonicSelector) {
                        SwiftUITonicSelector(keysPerRow: keysPerRow, noteOff: viewConductor.noteOff)
                            .aspectRatio(CGFloat(keysPerRow), contentMode: .fit)
                            .padding(.bottom, 10)
                    }
                    SwiftUIKeyboard(octaveCount: viewConductor.octaveCount, keysPerRow: keysPerRow, noteOn: viewConductor.noteOn(pitch:point:), noteOff: viewConductor.noteOff)
                        .frame(maxHeight: CGFloat(viewConductor.octaveCount) * 4.5 * (proxy.size.width / CGFloat(keysPerRow)))
//                        .aspectRatio(CGFloat(keysPerRow) / (CGFloat(viewConductor.octaveCount) * 4.5), contentMode: .fit)
                    Spacer()
                }
            }.onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    if !viewConductor.conductor.engine.isRunning {
                        try? viewConductor.conductor.instrument.loadInstrument(at: Bundle.main.url(forResource: "Sounds/YDP-GrandPiano-20160804", withExtension: "sf2")!)
                        try? viewConductor.conductor.engine.start()
                    }
                } else if newPhase == .background {
                    viewConductor.conductor.engine.stop()
                }
            }.onReceive(NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification)) { event in
                switch event.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt {
                case AVAudioSession.RouteChangeReason.newDeviceAvailable.rawValue:
                    reloadAudio()
                case AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue:
                    reloadAudio()
                default:
                    break
                }
            }.onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { event in
                guard let info = event.userInfo,
                      let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
                      let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                    return
                }
                if type == .began {
                    self.viewConductor.conductor.engine.stop()
                } else if type == .ended {
                    guard let optionsValue =
                            info[AVAudioSessionInterruptionOptionKey] as? UInt else {
                        return
                    }
                    if AVAudioSession.InterruptionOptions(rawValue: optionsValue).contains(.shouldResume) {
                        reloadAudio()
                    }
                }
            }
            .onDisappear() { self.viewConductor.conductor.engine.stop() }
            .environmentObject(viewConductor.midiManager)
        }
    }
    func reloadAudio() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !viewConductor.conductor.engine.isRunning {
                try? viewConductor.conductor.instrument.loadInstrument(at: Bundle.main.url(forResource: "Sounds/YDP-GrandPiano-20160804", withExtension: "sf2")!)
                viewConductor.conductor.start()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
