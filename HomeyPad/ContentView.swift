import SwiftUI
import AVFoundation
import Keyboard
import Tonic
import Controls

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewConductor = ViewConductor()
    @StateObject var midiPlayer = MIDIPlayer()
    @State private var showingSettingsPopover = false
    @State private var showingHelpPopover = false
    @State private var showingPlayPopover = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black
                ZStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center, spacing: 0) {
                            Toggle("", isOn: $viewConductor.showSelector).labelsHidden()
                                .tint(Default.pianoGray)
                            Button(action: {
                                self.showingSettingsPopover.toggle()
                            }) {
                                ZStack {
                                    Image(systemName: "slider.horizontal.3").foregroundColor(.white)
                                    Image(systemName: "square").foregroundColor(.clear)
                                }
                            }.popover(isPresented: $showingSettingsPopover,
                                      content: {
                                CustomizeView(showClassicalSelector: $viewConductor.showClassicalSelector,
                                              showMonthsSelector: $viewConductor.showMonthsSelector,
                                              showPianoSelector: $viewConductor.showPianoSelector,
                                              showIntervals: $viewConductor.showIntervals,
                                              octaveCount: $viewConductor.octaveCount,
                                              keysPerRow: $viewConductor.keysPerRow,
                                              midiPlayer: midiPlayer,
                                              viewConductor: viewConductor)
                                .presentationCompactAdaptation(.none)
                            })
                            .padding(.leading, 10)
                            Spacer()
                            HStack {
                                HStack {
                                    Stepper("", value: $viewConductor.keysPerRow,
                                            in: minKeysPerRow()...maxKeysPerRow(),
                                            step: 2).labelsHidden()
                                    Image(systemName: "arrow.left.and.line.vertical.and.arrow.right")
                                        .gridCellAnchor(.center)
                                }
                                HStack {
                                    Stepper("", value: $viewConductor.octaveCount,
                                            in: 1...7,
                                            step: 2).labelsHidden()
                                    Image(systemName: "arrow.up.and.line.horizontal.and.arrow.down")
                                        .gridCellAnchor(.center)
                                }
                                .padding(.leading, 32)
                            }
                            Spacer()
                            // Stop play pause buttons
                            if midiPlayer.state == .playing || midiPlayer.state == .paused {
                                VStack(alignment: .leading) {
                                    HStack(spacing: 0) {
                                        Button(action: {
                                            midiPlayer.rewind()
                                            viewConductor.simpleSuccess()
                                        }) {
                                            Image(systemName: "backward.end.circle.fill").foregroundColor(.white)
                                        }
                                        Button(action: {
                                            viewConductor.nowPlayingID = 0
                                            midiPlayer.stop()
                                        }) {
                                            Image(systemName: "stop.circle.fill").foregroundColor(.white)
                                        }
                                        .padding(.leading, 5)
                                        if midiPlayer.state == .playing {
                                            Button(action: {
                                                midiPlayer.pause()
                                            }) {
                                                Image(systemName: "pause.circle.fill").foregroundColor(.white)
                                            }
                                            .padding(.leading, 5)
                                        } else if midiPlayer.state == .paused {
                                            Button(action: {
                                                midiPlayer.play()
                                            }) {
                                                Image(systemName: "play.circle.fill").foregroundColor(.white)
                                            }
                                            .padding(.leading, 5)
                                        }
                                        Button( action: {
                                            self.showingPlayPopover.toggle()
                                            viewConductor.scrollToID = viewConductor.nowPlayingID
                                        }) {
                                            AnyView(viewConductor.nowPlayingTitle)
                                        }
                                        .padding(.leading, 20)
                                    }
                                }
                                .padding(.trailing, 20)
                            }
                            // The play view
                            VStack(alignment: .leading) {
                                HStack {
                                    Button(action: {
                                        self.showingPlayPopover.toggle()
                                        viewConductor.scrollToID = viewConductor.nowPlayingID
                                    }) {
                                        ZStack {
                                            Image(systemName: "music.note.list")
                                                .foregroundColor(.white)
                                            Image(systemName: "square")
                                                .foregroundColor(.clear)
                                        }
                                    }.popover(isPresented: $showingPlayPopover,
                                              content: {
                                        PlayView(viewConductor: viewConductor,
                                                 midiPlayer: midiPlayer,
                                                 nowPlayingTitle: $viewConductor.nowPlayingTitle,
                                                 nowPlayingID: $viewConductor.nowPlayingID,
                                                 scrollToID: $viewConductor.scrollToID)
                                            .presentationCompactAdaptation(.none)
                                    })
                                }
                            }
                            .padding(.trailing, 10)
                            // The help view
                            VStack(alignment: .leading) {
                                HStack {
                                    Button(action: {
                                        self.showingHelpPopover.toggle()
                                    }) {
                                        ZStack {
                                            Image(systemName: "questionmark.circle")
                                                .foregroundColor(.white)
                                            Image(systemName: "square")
                                                .foregroundColor(.clear)
                                        }
                                    }.popover(isPresented: $showingHelpPopover,
                                              content: {
                                        HelpView()
                                            .presentationCompactAdaptation(.none)
                                    })
                                }
                            }
                            .padding(.trailing, 10)
                        }
                        Spacer()
                    }
                    // keyboard
                    VStack(spacing: 0) {
                        // home selector
                        Spacer()
                        if (viewConductor.showSelector) {
                            // The tonic selector
                            SwiftUIHomeSelector(keysPerRow: viewConductor.keysPerRow,
                                                tonicPitchClass: viewConductor.tonicPitchClass,
                                                showClassicalSelector: viewConductor.showClassicalSelector,
                                                showMonthsSelector: viewConductor.showMonthsSelector,
                                                showPianoSelector: viewConductor.showPianoSelector,
                                                showIntervals: viewConductor.showIntervals,
                                                midiPlayer: midiPlayer,
                                                selectorTapped: viewConductor.selectHome)
                            .aspectRatio(CGFloat(viewConductor.keysPerRow), contentMode: .fit)
                            .padding(.bottom, 7)
                        }
                        // The main dualistic keyboard
                        SwiftUIKeyboard(octaveCount: viewConductor.octaveCount, keysPerRow: viewConductor.keysPerRow, tonicPitchClass: viewConductor.tonicPitchClass, noteOn: viewConductor.noteOn(pitch:point:), noteOff: viewConductor.noteOff, row: 0, col: 0)
                            .frame(maxHeight: CGFloat(viewConductor.octaveCount) * 4.5 * (proxy.size.width / CGFloat(viewConductor.keysPerRow)))
                        Spacer()
                    }
                    .padding([.top, .bottom], 35)
                }
            }.onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    if !viewConductor.conductor.engine.avEngine.isRunning {
                        viewConductor.conductor.start()
                    }
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
                    if midiPlayer.state == .playing {midiPlayer.pause()}
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
            .onDisappear() {
                if midiPlayer.state == .playing {midiPlayer.pause()}
                self.viewConductor.conductor.engine.stop()
            }
            .environmentObject(viewConductor.midiManager)
            .statusBar(hidden: true)
        }
        .padding(.top, 25)
    }
    func reloadAudio() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !viewConductor.conductor.engine.avEngine.isRunning {
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
