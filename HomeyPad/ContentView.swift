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
        
        ZStack {
            Color.black
            GeometryReader { proxy in
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
                                              linearLayoutOctaveCount: $viewConductor.linearLayoutOctaveCount,
                                              linearLayoutKeysPerRow: $viewConductor.linearLayoutKeysPerRow,
                                              gridLayoutOctaveCount: $viewConductor.gridLayoutOctaveCount,
                                              gridLayoutKeysPerRow: $viewConductor.gridLayoutKeysPerRow,
                                              midiPlayer: midiPlayer,
                                              viewConductor: viewConductor)
                                .presentationCompactAdaptation(.none)
                            })
                            .padding(.leading, 10)
                            Spacer()
                            /// stepper for rows and columns
                            HStack {
                                /// rows
                                let fewerRowsDisabled : Bool = (((viewConductor.layout == .linear) && viewConductor.linearLayoutOctaveCount <= 1) || ((viewConductor.layout == .grid) && viewConductor.gridLayoutOctaveCount <= 1))
                                let moreRowsDisabled : Bool = (((viewConductor.layout == .linear) && viewConductor.linearLayoutOctaveCount >= 9) || ((viewConductor.layout == .grid) && viewConductor.gridLayoutOctaveCount >= 5))
                                HStack(spacing: 10) {
                                    Button(action: {
                                        switch viewConductor.layout {
                                        case .linear:
                                            viewConductor.linearLayoutOctaveCount -= 2
                                        case .grid:
                                            viewConductor.gridLayoutOctaveCount -= 2
                                        default:
                                            print("not implemented yet")
                                        }
                                    }, label: {
                                        Image(systemName: "arrow.down.and.line.horizontal.and.arrow.up")
                                            .foregroundColor(fewerRowsDisabled ? Color(UIColor.systemGray4) : .white)
                                            .padding([.leading, .trailing], 3)
                                    })
                                    .disabled(fewerRowsDisabled)
                                    Divider()
                                        .frame(width: 2)
                                        .overlay(Color(UIColor.systemGray4))
                                    Button(action: {
                                        switch viewConductor.layout {
                                        case .linear:
                                            viewConductor.linearLayoutOctaveCount += 2
                                        case .grid:
                                            viewConductor.gridLayoutOctaveCount += 2
                                        default:
                                            print("not implemented yet")
                                        }
                                    }, label: {
                                        Image(systemName: "arrow.up.and.line.horizontal.and.arrow.down")
                                            .foregroundColor(moreRowsDisabled ? Color(UIColor.systemGray4) : .white)
                                            .padding([.leading, .trailing], 4)
                                    })
                                    .disabled(moreRowsDisabled)
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
                                let defaultGeometry : Bool = ((viewConductor.layout == .linear) && viewConductor.linearLayoutOctaveCount == Default.linearLayoutOctaveCount && viewConductor.linearLayoutKeysPerRow == Default.linearLayoutKeysPerRow) ||
                                ((viewConductor.layout == .grid) && viewConductor.gridLayoutOctaveCount == Default.gridLayoutOctaveCount && viewConductor.gridLayoutKeysPerRow == Default.gridLayoutKeysPerRow)
                                Button(role: .cancel, action: {
                                    switch viewConductor.layout {
                                    case .linear:
                                        viewConductor.linearLayoutOctaveCount = Default.linearLayoutOctaveCount
                                        viewConductor.linearLayoutKeysPerRow = Default.linearLayoutKeysPerRow
                                    case .grid:
                                        viewConductor.gridLayoutOctaveCount = Default.gridLayoutOctaveCount
                                        viewConductor.gridLayoutKeysPerRow = Default.gridLayoutKeysPerRow
                                    default:
                                        print("not implemented yet")
                                    }
                                }) {
                                    ZStack {
                                        Image(systemName: "gobackward")
                                            .foregroundColor(defaultGeometry ? Default.pianoGray : .white)
                                        Image(systemName: "square").foregroundColor(.clear)
                                    }
                                }
                                .disabled(defaultGeometry)
                                
                                /// columns
                                let fewerColsDisabled : Bool = (((viewConductor.layout == .linear) && viewConductor.linearLayoutKeysPerRow <= minKeysPerRow()) ||
                                                                ((viewConductor.layout == .grid) && viewConductor.gridLayoutKeysPerRow <= minKeysPerRow()))
                                let moreColsDisabled : Bool = (((viewConductor.layout == .linear) && viewConductor.linearLayoutKeysPerRow >= maxKeysPerRow(layout: viewConductor.layout)) ||
                                                               ((viewConductor.layout == .grid) && viewConductor.gridLayoutKeysPerRow >= maxKeysPerRow(layout: viewConductor.layout)))
                                HStack(spacing: 10) {
                                    HStack {
                                        Button(action: {
                                            switch viewConductor.layout {
                                            case .linear:
                                                viewConductor.linearLayoutKeysPerRow -= 2
                                            case .grid:
                                                switch viewConductor.colsPerRow() {
                                                case 10:
                                                    viewConductor.gridLayoutKeysPerRow -= 4
                                                case 12:
                                                    viewConductor.gridLayoutKeysPerRow -= 4
                                                case 16:
                                                    viewConductor.gridLayoutKeysPerRow -= 6
                                                case 18:
                                                    viewConductor.gridLayoutKeysPerRow -= 4
                                                case 20:
                                                    viewConductor.gridLayoutKeysPerRow -= 4
                                                case 22:
                                                    viewConductor.gridLayoutKeysPerRow -= 2
                                                case 27:
                                                    viewConductor.gridLayoutKeysPerRow -= 4
                                                case 29:
                                                    viewConductor.gridLayoutKeysPerRow -= 4
                                                case 33:
                                                    viewConductor.gridLayoutKeysPerRow -= 6
                                                case 35:
                                                    viewConductor.gridLayoutKeysPerRow -= 4
                                                case 37:
                                                    viewConductor.gridLayoutKeysPerRow -= 4
                                                case 39:
                                                    viewConductor.gridLayoutKeysPerRow -= 2
                                                default:
                                                    viewConductor.gridLayoutKeysPerRow -= 2
                                                }
                                            default:
                                                print("not implemented yet")
                                            }
                                        }, label: {
                                            Image(systemName: "arrow.right.and.line.vertical.and.arrow.left")
                                                .foregroundColor(fewerColsDisabled ? Color(UIColor.systemGray4) : .white)
                                                .padding([.top, .bottom], 2)
                                        })
                                        .disabled(fewerColsDisabled)
                                        Divider()
                                            .frame(width: 2)
                                            .overlay(Color(UIColor.systemGray4))
                                        Button(action: {
                                            switch viewConductor.layout {
                                            case .linear:
                                                viewConductor.linearLayoutKeysPerRow += 2
                                            case .grid:
                                                switch viewConductor.colsPerRow() {
                                                case 8: 
                                                    viewConductor.gridLayoutKeysPerRow += 4
                                                case 10: 
                                                    viewConductor.gridLayoutKeysPerRow += 4
                                                case 12: 
                                                    viewConductor.gridLayoutKeysPerRow += 6
                                                case 16: 
                                                    viewConductor.gridLayoutKeysPerRow += 4
                                                case 18: 
                                                    viewConductor.gridLayoutKeysPerRow += 4
                                                case 20: 
                                                    viewConductor.gridLayoutKeysPerRow += 2
                                                case 22: 
                                                    viewConductor.gridLayoutKeysPerRow += 4
                                                case 27: 
                                                    viewConductor.gridLayoutKeysPerRow += 4
                                                case 29: 
                                                    viewConductor.gridLayoutKeysPerRow += 6
                                                case 33: 
                                                    viewConductor.gridLayoutKeysPerRow += 4
                                                case 35: 
                                                    viewConductor.gridLayoutKeysPerRow += 4
                                                case 37: 
                                                    viewConductor.gridLayoutKeysPerRow += 2
                                                default:
                                                    viewConductor.gridLayoutKeysPerRow += 0
                                                }
                                            default:
                                                print("not implemented yet")
                                            }
                                        }, label: {
                                            Image(systemName: "arrow.left.and.line.vertical.and.arrow.right")
                                                .foregroundColor(moreColsDisabled ? Color(UIColor.systemGray4) : .white)
                                                .padding([.top, .bottom], 2)
                                        })
                                        .disabled(moreColsDisabled)
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
                            .padding(.leading, 57)
                            Spacer()
                            /// select layout
                            Picker("", selection: $viewConductor.layout) {
                                Image(systemName: "rectangle.split.2x1.fill")
                                    .tag(HomeyLayout.linear.rawValue)
                                Image(systemName: "rectangle.split.2x2.fill")
                                    .tag(HomeyLayout.grid.rawValue)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 75)
                            .padding(.trailing, 10)
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
                                            viewConductor.simpleSuccess()
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
                            SwiftUIHomeSelector(viewConductor: viewConductor,
                                                layout: viewConductor.layout,
                                                linearLayoutKeysPerRow: viewConductor.linearLayoutKeysPerRow,
                                                gridLayoutKeysPerRow: viewConductor.gridLayoutKeysPerRow,
                                                tonicPitchClass: viewConductor.tonicPitchClass,
                                                showClassicalSelector: viewConductor.showClassicalSelector,
                                                showIntegersSelector: viewConductor.showIntegersSelector,
                                                showRomanSelector: viewConductor.showRomanSelector,
                                                showDegreeSelector: viewConductor.showDegreeSelector,
                                                showMonthsSelector: viewConductor.showMonthsSelector,
                                                showPianoSelector: viewConductor.showPianoSelector,
                                                showIntervals: viewConductor.showIntervals,
                                                midiPlayer: midiPlayer,
                                                upwardPitchMovement: viewConductor.upwardPitchMovement
                            )
                            .aspectRatio(CGFloat(viewConductor.colsPerRow()), contentMode: .fit)
                            .padding(.bottom, 7)
                        }
                        /// The main  keyboard
                        SwiftUIKeyboard(
                            layout: viewConductor.layout,
                            octaveShift: viewConductor.octaveShift,
                            linearLayoutOctaveCount: viewConductor.linearLayoutOctaveCount, 
                            linearLayoutKeysPerRow: viewConductor.linearLayoutKeysPerRow,
                            gridLayoutOctaveCount: viewConductor.gridLayoutOctaveCount,
                            gridLayoutKeysPerRow: viewConductor.gridLayoutKeysPerRow,
                            tonicPitchClass: viewConductor.tonicPitchClass,
                            upwardPitchMovement: viewConductor.upwardPitchMovement,
                            noteOn: viewConductor.noteOn(pitch:point:),
                            noteOff: viewConductor.noteOff)
                        .frame(maxHeight: CGFloat(viewConductor.octaveCount()) * 5.0 * (proxy.size.width / CGFloat(viewConductor.colsPerRow())))
                        Spacer()
                    }
                    .padding([.top, .bottom], 35)
                    
                    VStack {
                        Spacer()
                        HStack(alignment: .center, spacing: 0) {
                            /// octave shift
                            HStack(spacing: 10) {
                                Button(action: {
                                    viewConductor.octaveShift -= 1
                                }, label: {
                                    Image(systemName: "water.waves.and.arrow.down")
                                        .foregroundColor(viewConductor.octaveShift <= -4 ? Color(UIColor.systemGray4) : .white)
                                })
                                .disabled(viewConductor.octaveShift <= -4)
                                Text(viewConductor.octaveShift.formatted(.number.sign(strategy: .always(includingZero: false))))
                                    .font(Font.system(.body, design: .monospaced))
                                    .fixedSize(horizontal: true, vertical: false)
                                    .frame(width: 53, alignment: .center)
                                    .foregroundStyle(Color(UIColor.systemGray))
                                Button(action: {
                                    viewConductor.octaveShift += 1
                                }, label: {
                                    Image(systemName: "water.waves.and.arrow.up")
                                        .foregroundColor(viewConductor.octaveShift >= 4 ? Color(UIColor.systemGray4) : .white)
                                })
                                .disabled(viewConductor.octaveShift  >= 4)
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
                }
            }
            .onChange(of: scenePhase) { newPhase in
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
            .statusBar(hidden: true)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .padding(.top, 25)
        }
        .ignoresSafeArea(edges:.horizontal)
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
