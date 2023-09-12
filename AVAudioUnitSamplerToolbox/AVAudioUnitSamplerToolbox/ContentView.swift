import SwiftUI
import AVFoundation
import Keyboard
import Tonic
import Controls

struct ContentView: View {
    @StateObject var viewConductor = ViewConductor()
    @Environment(\.scenePhase) var scenePhase
    
    @State private var value = 0
    @State private var showingPopover = false
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
            
            ZStack {
                Color.black
                ZStack {
                    VStack(spacing: 0) {
                        Spacer()
                        if (viewConductor.tonicSelector) {
                            SwiftUITonicSelector(keysPerRow: viewConductor.keysPerRow, noteOff: viewConductor.noteOff)
                                .aspectRatio(CGFloat(viewConductor.keysPerRow), contentMode: .fit)
                                .padding(.bottom, 5)
                        }
                        SwiftUIKeyboard(octaveCount: viewConductor.octaveCount, keysPerRow: viewConductor.keysPerRow, noteOn: viewConductor.noteOn(pitch:point:), noteOff: viewConductor.noteOff)
                            .frame(maxHeight: CGFloat(viewConductor.octaveCount) * 4.5 * (proxy.size.width / CGFloat(viewConductor.keysPerRow)))
                        //                        .aspectRatio(CGFloat(keysPerRow) / (CGFloat(viewConductor.octaveCount) * 4.5), contentMode: .fit)
                        Spacer()
                    }
                    .padding([.top, .bottom], 40)
                    VStack(alignment: .trailing) {
                        HStack {
                            Spacer()
                            Button() {
                                self.showingPopover = true
                            } label: {
                                Image(systemName: "ellipsis.circle").foregroundColor(.white)
                            }
                            .popover(isPresented: $showingPopover) {
                                NavigationView {
                                    List {
                                        Section {
                                            Toggle(isOn: $viewConductor.tonicSelector) {
                                                Label("Notes", systemImage: "music.quarternote.3")
                                            }
                                            Stepper(value: $viewConductor.octaveCount,
                                                    in: 1...8,
                                                    step: 1) {
                                                Label("Rows", systemImage: "arrow.up.and.line.horizontal.and.arrow.down")
                                            }
                                            Stepper(value: $viewConductor.keysPerRow,
                                                    in: 13...37,
                                                    step: 2) {
//                                                Label("Columns", systemImage: "arrow.left.and.line.vertical.and.arrow.right")
                                                Label("Columns", systemImage: "arrow.left.and.line.vertical.and.arrow.right")
                                            }
                                        }
                                        Section {
                                            Button(role: .cancel, action: {
                                                viewConductor.tonicSelector = false
                                                viewConductor.octaveCount = 1
                                                viewConductor.keysPerRow = 25
                                                showingPopover = false
                                            }) {
                                                Label("Reset", systemImage: "gobackward")
                                            }
                                        }
                                    }
                                    .navigationViewStyle(StackNavigationViewStyle())
                                    .navigationBarTitle("Settings", displayMode: .inline)
                                    .toolbar {
                                        Button("Done") {
                                            showingPopover = false
                                        }
                                    }
                                }
                            }
                            .padding([.top, .trailing], 10)
                        }
                        Spacer()
                    }
                    .statusBar(hidden: true)
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
