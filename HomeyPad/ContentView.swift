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
                ZStack {
                    VStack {
                        HStack(alignment: .center, spacing: 0) {
                            /// tonic selector toggle
                            Toggle("", isOn: $viewConductor.showSelector).labelsHidden()
                                .tint(Default.pianoGray)
                                .padding(.leading, 10)
                            /// show or hide label picker for tonic selector
                            Button(action: {
                                self.showingSettingsPopover.toggle()
                            }) {
                                ZStack {
                                    Image(systemName: "slider.horizontal.3")
                                        .foregroundColor(viewConductor.showSelector ? .white : Default.pianoGray)
                                    Image(systemName: "square").foregroundColor(.clear)
                                }
                            }
                            .disabled(!viewConductor.showSelector)
                            .popover(isPresented: $showingSettingsPopover,
                                      content: {
                                /// labels for tonic selector
                                CustomizeView(showClassicalSelector: $viewConductor.showClassicalSelector,
                                              showIntegersSelector: $viewConductor.showIntegersSelector,
                                              showRomanSelector: $viewConductor.showRomanSelector,
                                              showDegreeSelector: $viewConductor.showDegreeSelector,
                                              showMonthsSelector: $viewConductor.showMonthsSelector,
                                              showPianoSelector: $viewConductor.showPianoSelector,
                                              showIntervals: $viewConductor.showIntervals,
                                              octaveCount: $viewConductor.octaveCount,
                                              keysPerRow: $viewConductor.keysPerRow,
                                              upwardPitchMovement: $viewConductor.upwardPitchMovement, midiPlayer: midiPlayer,
                                              viewConductor: viewConductor)
                                .presentationCompactAdaptation(.none)
                            })
                            .padding(.leading, 10)
                            Spacer()
                            /// stepper for rows and columns
                            HStack {
                                /// columns
                                HStack(spacing: 10) {
                                    Button(action: {
                                        viewConductor.octaveCount -= 2
                                    }, label: {
                                        Image(systemName: "arrow.down.and.line.horizontal.and.arrow.up")
                                            .foregroundColor(viewConductor.octaveCount <= 1 ? Color(UIColor.systemGray4) : .white)
                                            .padding([.leading, .trailing], 3)
                                    })
                                    .disabled(viewConductor.octaveCount <= 1)
                                    Divider()
                                        .frame(width: 2)
                                        .overlay(Color(UIColor.systemGray4))
                                    Button(action: {
                                        viewConductor.octaveCount += 2
                                    }, label: {
                                        Image(systemName: "arrow.up.and.line.horizontal.and.arrow.down")
                                            .foregroundColor(viewConductor.octaveCount >= 9 ? Color(UIColor.systemGray4) : .white)
                                            .padding([.leading, .trailing], 4)
                                    })
                                    .disabled(viewConductor.octaveCount  >= 9)
                                }
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 4 * 2)
                                .foregroundColor(.white)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color(UIColor.systemGray6))
                                }

                                /// reset
                                let defaultGeometry = viewConductor.octaveCount == Default.octaveCount && viewConductor.keysPerRow == Default.keysPerRow
                                Button(role: .cancel, action: {
                                    viewConductor.octaveCount = Default.octaveCount
                                    viewConductor.keysPerRow = Default.keysPerRow
                                }) {
                                    ZStack {
                                        Image(systemName: "gobackward")
                                            .foregroundColor(defaultGeometry ? Default.pianoGray : .white)
                                        Image(systemName: "square").foregroundColor(.clear)
                                    }
                                }
                                .disabled(defaultGeometry)
                                
                                /// columns
                                HStack(spacing: 10) {
                                    HStack {
                                        Button(action: {
                                            viewConductor.keysPerRow -= 2
                                        }, label: {
                                            Image(systemName: "arrow.right.and.line.vertical.and.arrow.left")
                                                .foregroundColor(viewConductor.keysPerRow <= minKeysPerRow() ? Color(UIColor.systemGray4) : .white)
                                                .padding([.top, .bottom], 2)
                                        })
                                        .disabled(viewConductor.keysPerRow <= minKeysPerRow())
                                        Divider()
                                            .frame(width: 2)
                                            .overlay(Color(UIColor.systemGray4))
                                        Button(action: {
                                            viewConductor.keysPerRow += 2
                                        }, label: {
                                            Image(systemName: "arrow.left.and.line.vertical.and.arrow.right")
                                                .foregroundColor(viewConductor.keysPerRow >= maxKeysPerRow() ? Color(UIColor.systemGray4) : .white)
                                                .padding([.top, .bottom], 2)
                                        })
                                        .disabled(viewConductor.keysPerRow >= maxKeysPerRow())
                                    }
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 4 * 2)
                                    .foregroundColor(.white)
                                    .background {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color(UIColor.systemGray6))
                                    }
                                }
                            }
                            .padding(.trailing, 28)
                            Spacer()
                            /// Stop play pause buttons
                            if midiPlayer.state == .playing || midiPlayer.state == .paused {
                                VStack(alignment: .leading) {
                                    HStack(spacing: 0) {
                                        Button(action: {
                                            midiPlayer.rewind()
                                            viewConductor.simpleSuccess()
                                        }) {
                                            Image(systemName: "backward.end.circle.fill").foregroundColor(.white)
                                        }
                                        .padding(.trailing, 5)
                                        Button(action: {
                                            viewConductor.nowPlayingID = 0
                                            midiPlayer.stop()
                                        }) {
                                            Image(systemName: "stop.circle.fill").foregroundColor(.white)
                                        }
                                        .padding(.trailing, 5)
                                        if midiPlayer.state == .playing {
                                            Button(action: {
                                                midiPlayer.pause()
                                            }) {
                                                Image(systemName: "pause.circle.fill").foregroundColor(.white)
                                            }
                                        } else if midiPlayer.state == .paused {
                                            Button(action: {
                                                midiPlayer.play()
                                            }) {
                                                Image(systemName: "play.circle.fill").foregroundColor(.white)
                                            }
                                        }
                                        Button( action: {
                                            self.showingPlayPopover.toggle()
                                            viewConductor.scrollToID = viewConductor.nowPlayingID
                                        }) {
                                            AnyView(viewConductor.nowPlayingTitle)
                                        }
                                        .padding([.leading, .trailing], 10)
                                    }
                                }
                            }
                            /// The play view
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
                            /// The help view
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
                    /// keyboard
                    VStack(spacing: 0) {
                        /// home selector
                        Spacer()
                        if (viewConductor.showSelector) {
                            SwiftUIHomeSelector(keysPerRow: viewConductor.keysPerRow,
                                                tonicPitchClass: viewConductor.tonicPitchClass,
                                                showClassicalSelector: viewConductor.showClassicalSelector,
                                                showIntegersSelector: viewConductor.showIntegersSelector,
                                                showRomanSelector: viewConductor.showRomanSelector,
                                                showDegreeSelector: viewConductor.showDegreeSelector,
                                                showMonthsSelector: viewConductor.showMonthsSelector,
                                                showPianoSelector: viewConductor.showPianoSelector,
                                                showIntervals: viewConductor.showIntervals,
                                                midiPlayer: midiPlayer,
                                                selectorTapped: viewConductor.selectHome,
                                                upwardPitchMovement: viewConductor.upwardPitchMovement)
                            .aspectRatio(CGFloat(viewConductor.keysPerRow), contentMode: .fit)
                            .padding(.bottom, 7)
                        }
                        /// The main dualistic keyboard
                        SwiftUIKeyboard(octaveCount: viewConductor.octaveCount, keysPerRow: viewConductor.keysPerRow, tonicPitchClass: viewConductor.tonicPitchClass, noteOn: viewConductor.noteOn(pitch:point:), noteOff: viewConductor.noteOff)
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
