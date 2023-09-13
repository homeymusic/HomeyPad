import SwiftUI
import AVFoundation
import Keyboard
import Tonic
import Controls

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewConductor = ViewConductor()
    @State private var showingPopover = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black
                ZStack {
                    VStack(spacing: 0) {
                        Spacer()
                        if (viewConductor.tonicSelector) {
                            // The tonic selector
                            SwiftUITonicSelector(keysPerRow: viewConductor.keysPerRow, tonicPitchClass: viewConductor.tonicPitchClass, noteOff: viewConductor.selectTonic)
                                .aspectRatio(CGFloat(viewConductor.keysPerRow), contentMode: .fit)
                                .padding(.bottom, 5)
                        }
                        // The main dualistic keyboard
                        SwiftUIKeyboard(octaveCount: viewConductor.octaveCount, keysPerRow: viewConductor.keysPerRow, tonicPitchClass: viewConductor.tonicPitchClass, noteOn: viewConductor.noteOn(pitch:point:), noteOff: viewConductor.noteOff)
                            .frame(maxHeight: CGFloat(viewConductor.octaveCount) * 4.5 * (proxy.size.width / CGFloat(viewConductor.keysPerRow)))
                        Spacer()
                    }
                    // Padding to protect the settings icon
                    // top and bottom for symmetry
                    .padding([.top, .bottom], 30)
                    // The settings view
                    VStack(alignment: .trailing) {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.showingPopover.toggle()
                            }) {
                                Image(systemName: "ellipsis.circle").foregroundColor(.white)
                            }.popover(isPresented: $showingPopover,
                                      content: {
                                SettingsView(tonicSelector: $viewConductor.tonicSelector, octaveCount: $viewConductor.octaveCount,keysPerRow: $viewConductor.keysPerRow)
                                    .presentationCompactAdaptation(.none)
                            })
                        }
                        Spacer()
                    }
                    .padding([.top, .trailing], 10)
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
            .statusBar(hidden: true)
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
