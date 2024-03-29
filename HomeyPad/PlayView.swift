//
//  SettingsView.swift
//
//  Created by Brian McAuliff Mulloy on 9/12/23.
//

import SwiftUI
import AudioKit

struct PlayView: View {
    @Environment(\.dismiss) var dismiss
    var viewConductor: ViewConductor
    var midiPlayer: MIDIPlayer
    @Binding var nowPlayingTitle: any View
    @Binding var nowPlayingID: Int
    @Binding var scrollToID: Int
    
    func initSequencer(nowPlaying: any View, filename: String, songTonic: Int, itemID: Int) {
        midiPlayer.stop()
        let midiCallback = MIDICallbackInstrument()
        
        self.nowPlayingTitle = nowPlaying
        self.nowPlayingID = itemID
        
        midiCallback.callback = { status, note, velocity in
            let midiNote: UInt8 = UInt8(Default.initialC - songTonic + viewConductor.octaveShift * 12 + viewConductor.tonicPitchClass + Int(note))
            if status == 144 {
                viewConductor.playNote(midiNote)
            } else if status == 128 {
                viewConductor.stopNote(midiNote)
            }
        }
        midiPlayer.sequencer.loadMIDIFile(fromURL: Bundle.main.url(forResource: filename, withExtension: "mid", subdirectory: "Examples")!)
        midiPlayer.sequencer.setGlobalMIDIOutput(midiCallback.midiIn)
        midiPlayer.sequencer.enableLooping()
        midiPlayer.sequencer.preroll()
        midiPlayer.rewind()
        midiPlayer.play()
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Play")
                    .font(.headline)
                Spacer()
            }
            .padding(.top, 10)
            Divider()
            ScrollView {
                ScrollViewReader { (proxy: ScrollViewProxy) in
                    VStack(alignment: .leading, spacing: 5) {
                        Group {
                            HStack {
                                Text("Tunes")
                                    .font(.subheadline)
                                Spacer()
                            }
                            .padding(.bottom, 5)
                            Button {
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Twinkle Twinkle Little Star")
                                        .foregroundColor(Default.majorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "plus.square.fill")
                                            .foregroundColor(Default.majorColor)
                                        Image(systemName: "greaterthan.square")
                                            .foregroundColor(Default.majorColor)
                                    }
                                }, filename: "twinkle_twinkle_little_star", songTonic: 48, itemID: 1)
                                viewConductor.setPitchMovement(true)
                                if viewConductor.gridLayoutKeysPerRow < 13 {viewConductor.gridLayoutKeysPerRow = 13}
                                dismiss()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 1 { Default.highlightGray }
                                    HStack {
                                        Text("Twinkle Twinkle Little Star")
                                            .foregroundColor(Default.majorColor)
                                            .underline()
                                            .id(1)
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Image(systemName: "plus.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "greaterthan.square")
                                                .foregroundColor(Default.majorColor)
                                        }
                                    }
                                }
                            }
                            Button {
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Twinkle Twinkle (mirror)")
                                        .foregroundColor(Default.minorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "minus.square.fill")
                                            .foregroundColor(Default.minorColor)
                                        Image(systemName: "lessthan.square")
                                            .foregroundColor(Default.minorColor)
                                    }
                                }, filename: "mirror_twinkle", songTonic: 40, itemID: 2)
                                viewConductor.setPitchMovement(false)
                                if viewConductor.gridLayoutKeysPerRow < 13 {viewConductor.gridLayoutKeysPerRow = 13}
                                dismiss()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 2 { Default.highlightGray }
                                    HStack {
                                        Text("Twinkle Twinkle (mirror)")
                                            .foregroundColor(Default.minorColor)
                                            .underline()
                                            .id(2)
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "lessthan.square")
                                                .foregroundColor(Default.minorColor)
                                        }
                                    }
                                }
                            }
                            Button {
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Happy Birthday")
                                        .foregroundColor(Default.majorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "plus.square.fill")
                                            .foregroundColor(Default.majorColor)
                                        Image(systemName: "lessthan.square")
                                            .foregroundColor(Default.majorColor)
                                    }
                                }, filename: "happy_birthday", songTonic: 55, itemID: 5)
                                viewConductor.setPitchMovement(true)
                                if viewConductor.gridLayoutKeysPerRow < 17 {viewConductor.gridLayoutKeysPerRow = 17}
                                dismiss()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 5 { Default.highlightGray }
                                    HStack {
                                        Text("Happy Birthday")
                                            .foregroundColor(Default.majorColor)
                                            .underline()
                                            .id(5)
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Image(systemName: "plus.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "lessthan.square")
                                                .foregroundColor(Default.majorColor)
                                        }
                                    }
                                }
                            }
                            Button {
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Happy Birthday (mirror)")
                                        .foregroundColor(Default.minorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "minus.square.fill")
                                            .foregroundColor(Default.minorColor)
                                        Image(systemName: "greaterthan.square")
                                            .foregroundColor(Default.minorColor)
                                    }
                                }, filename: "mirror_birthday", songTonic: 57, itemID: 6)
                                viewConductor.setPitchMovement(false)
                                if viewConductor.gridLayoutKeysPerRow < 17 {viewConductor.gridLayoutKeysPerRow = 17}
                                dismiss()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 6 { Default.highlightGray }
                                    HStack {
                                        Text("Happy Birthday (mirror)")
                                            .foregroundColor(Default.minorColor)
                                            .underline()
                                            .id(6)
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "greaterthan.square")
                                                .foregroundColor(Default.minorColor)
                                        }
                                    }
                                }
                            }
                            /// Saint James
                            Button {
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Saint James")
                                        .foregroundColor(Default.minorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "paintpalette")
                                            .symbolRenderingMode(.multicolor)
                                        Image(systemName: "minus.square.fill")
                                            .foregroundColor(Default.minorColor)
                                        Image(systemName: "greaterthan.square")
                                            .foregroundColor(Default.majorColor)
                                    }
                                }, filename: "saint", songTonic: 60, itemID: 22)
                                viewConductor.setPitchMovement(true)
                                if viewConductor.gridLayoutKeysPerRow < 17 {viewConductor.gridLayoutKeysPerRow = 17}
                                dismiss()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 22 { Default.highlightGray }
                                    HStack {
                                        Text("Saint James")
                                            .foregroundColor(Default.minorColor)
                                            .underline()
                                            .id(22)
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Image(systemName: "paintpalette")
                                                .symbolRenderingMode(.multicolor)
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "greaterthan.square")
                                                .foregroundColor(Default.majorColor)
                                        }
                                    }
                                }
                            }
                            Button {
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Saint James (mirror)")
                                        .foregroundColor(Default.majorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "paintpalette")
                                            .symbolRenderingMode(.multicolor)
                                        Image(systemName: "plus.square.fill")
                                            .foregroundColor(Default.majorColor)
                                        Image(systemName: "lessthan.square")
                                            .foregroundColor(Default.minorColor)
                                    }
                                }, filename: "mirror_saint", songTonic: 60, itemID: 23)
                                viewConductor.setPitchMovement(false)
                                if viewConductor.gridLayoutKeysPerRow < 17 {viewConductor.gridLayoutKeysPerRow = 17}
                                dismiss()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 23 { Default.highlightGray }
                                    HStack {
                                        Text("Saint James (mirror)")
                                            .foregroundColor(Default.majorColor)
                                            .underline()
                                            .id(23)
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Image(systemName: "paintpalette")
                                                .symbolRenderingMode(.multicolor)
                                            Image(systemName: "plus.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "lessthan.square")
                                                .foregroundColor(Default.minorColor)
                                        }
                                    }
                                }
                            }

                        }
                        Divider()
                            .padding(5)
                        Group {
                            HStack {
                                Text("Progressions")
                                    .font(.subheadline)
                                Spacer()
                            }
                            .padding(.bottom, 5)
                            Button {
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Ionian (Major)")
                                        .foregroundColor(Default.majorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "plus.square.fill")
                                            .foregroundColor(Default.majorColor)
                                        Image(systemName: "greaterthan.square")
                                            .foregroundColor(Default.majorColor)
                                    }
                                }, filename: "ionian", songTonic: 48, itemID: 11)
                                viewConductor.setPitchMovement(true)
                                if viewConductor.gridLayoutKeysPerRow < 17 {viewConductor.gridLayoutKeysPerRow = 17}
                                dismiss()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 11 { Default.highlightGray }
                                    HStack {
                                        Text("Ionian (Major)")
                                            .foregroundColor(Default.majorColor)
                                            .underline()
                                            .id(11)
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Image(systemName: "plus.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "greaterthan.square")
                                                .foregroundColor(Default.majorColor)
                                        }
                                    }
                                }
                            }
                            Button {
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Phrygian")
                                        .foregroundColor(Default.minorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "minus.square.fill")
                                            .foregroundColor(Default.minorColor)
                                        Image(systemName: "lessthan.square")
                                            .foregroundColor(Default.minorColor)
                                    }
                                }, filename: "phrygian", songTonic: 52, itemID: 12)
                                viewConductor.setPitchMovement(false)
                                if viewConductor.gridLayoutKeysPerRow < 17 {viewConductor.gridLayoutKeysPerRow = 17}
                                dismiss()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 12 { Default.highlightGray }
                                    HStack {
                                        Text("Phrygian")
                                            .foregroundColor(Default.minorColor)
                                            .underline()
                                            .id(12)
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "lessthan.square")
                                                .foregroundColor(Default.minorColor)
                                        }
                                    }
                                }
                            }
                            Button {
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Mixolydian")
                                        .foregroundColor(Default.majorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "plus.square.fill")
                                            .foregroundColor(Default.majorColor)
                                        Image(systemName: "lessthan.square")
                                            .foregroundColor(Default.minorColor)
                                    }
                                }, filename: "mixolydian", songTonic: 55, itemID: 13)
                                viewConductor.setPitchMovement(false)
                                if viewConductor.gridLayoutKeysPerRow < 17 {viewConductor.gridLayoutKeysPerRow = 17}
                                dismiss()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 13 { Default.highlightGray }
                                    HStack {
                                        Text("Mixolydian")
                                            .foregroundColor(Default.majorColor)
                                            .underline()
                                            .id(13)
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Image(systemName: "plus.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "lessthan.square")
                                                .foregroundColor(Default.minorColor)
                                        }
                                    }
                                }
                            }
                            Button {
                                initSequencer(nowPlaying:
                                                HStack {
                                    Text("Aeolian (Natural Minor)")
                                        .foregroundColor(Default.minorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "minus.square.fill")
                                            .foregroundColor(Default.minorColor)
                                        Image(systemName: "greaterthan.square")
                                            .foregroundColor(Default.majorColor)
                                    }
                                }, filename: "aeolian", songTonic: 69, itemID: 14)
                                viewConductor.setPitchMovement(true)
                                if viewConductor.gridLayoutKeysPerRow < 17 {viewConductor.gridLayoutKeysPerRow = 17}
                                dismiss()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 14 { Default.highlightGray }
                                    HStack {
                                        Text("Aeolian (Natural Minor)")
                                            .foregroundColor(Default.minorColor)
                                            .underline()
                                            .id(14)
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "greaterthan.square")
                                                .foregroundColor(Default.majorColor)
                                        }
                                    }
                                }
                            }
                            Button {
                                initSequencer(nowPlaying:
                                                HStack {
                                    Text("Harmonic Minor")
                                        .foregroundColor(Default.minorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "minus.square.fill")
                                            .foregroundColor(Default.minorColor)
                                        Image(systemName: "minus.square.fill")
                                            .foregroundColor(Default.minorColor)
                                        Image(systemName: "plus.square.fill")
                                            .foregroundColor(Default.majorColor)
                                        Image(systemName: "greaterthan.square")
                                            .foregroundColor(Default.majorColor)
                                    }
                                }, filename: "harmonic_minor", songTonic: 69, itemID: 15)
                                viewConductor.setPitchMovement(true)
                                if viewConductor.gridLayoutKeysPerRow < 17 {viewConductor.gridLayoutKeysPerRow = 17}
                                dismiss()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 15 { Default.highlightGray }
                                    HStack {
                                        Text("Harmonic Minor")
                                            .foregroundColor(Default.minorColor)
                                            .underline()
                                            .id(15)
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "plus.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "greaterthan.square")
                                                .foregroundColor(Default.majorColor)
                                        }
                                    }
                                }
                            }
                            Button {
                                initSequencer(nowPlaying: HStack {
                                    Text("Dorian Down")
                                        .foregroundColor(Default.majorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "plus.square.fill")
                                            .foregroundColor(Default.majorColor)
                                        Image(systemName: "minus.square.fill")
                                            .foregroundColor(Default.minorColor)
                                        Image(systemName: "plus.square.fill")
                                            .foregroundColor(Default.majorColor)
                                        Image(systemName: "lessthan.square")
                                            .foregroundColor(Default.minorColor)
                                    }
                                }, filename: "dorian_down", songTonic: 50, itemID: 16)
                                viewConductor.setPitchMovement(false)
                                if viewConductor.gridLayoutKeysPerRow < 17 {viewConductor.gridLayoutKeysPerRow = 17}
                                dismiss()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 16 { Default.highlightGray }
                                    HStack {
                                        Text("Dorian Down")
                                            .foregroundColor(Default.majorColor)
                                            .underline()
                                            .id(16)
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Image(systemName: "plus.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "plus.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "lessthan.square")
                                                .foregroundColor(Default.minorColor)
                                        }
                                    }
                                }
                            }
                            Button {
                                initSequencer(nowPlaying:
                                                HStack {
                                    Text("Dorian Up")
                                        .foregroundColor(Default.minorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "minus.square.fill")
                                            .foregroundColor(Default.minorColor)
                                        Image(systemName: "plus.square.fill")
                                            .foregroundColor(Default.majorColor)
                                        Image(systemName: "minus.square.fill")
                                            .foregroundColor(Default.minorColor)
                                        Image(systemName: "greaterthan.square")
                                            .foregroundColor(Default.majorColor)
                                    }
                                }, filename: "dorian_up", songTonic: 62, itemID: 17)
                                viewConductor.setPitchMovement(true)
                                if viewConductor.gridLayoutKeysPerRow < 17 {viewConductor.gridLayoutKeysPerRow = 17}
                                dismiss()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 17 { Default.highlightGray }
                                    HStack {
                                        Text("Dorian Up")
                                            .foregroundColor(Default.minorColor)
                                            .underline()
                                            .id(17)
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "plus.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "greaterthan.square")
                                                .foregroundColor(Default.majorColor)
                                        }
                                    }
                                }
                            }
                            Group {
                                Button {
                                    initSequencer(nowPlaying: HStack {
                                        Text("Lydian")
                                            .foregroundColor(Default.majorColor)
                                        HStack(spacing: 0) {
                                            Image(systemName: "plus.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "multiply.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "plus.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "greaterthan.square")
                                                .foregroundColor(Default.majorColor)
                                        }
                                    }, filename: "lydian", songTonic: 65, itemID: 18)
                                    viewConductor.setPitchMovement(true)
                                    if viewConductor.gridLayoutKeysPerRow < 17 {viewConductor.gridLayoutKeysPerRow = 17}
                                    dismiss()
                                } label: {
                                    ZStack {
                                        if self.scrollToID == 18 { Default.highlightGray }
                                        HStack {
                                            Text("Lydian")
                                                .foregroundColor(Default.majorColor)
                                                .underline()
                                                .id(18)
                                            Spacer()
                                            HStack(spacing: 0) {
                                                Image(systemName: "plus.square.fill")
                                                    .foregroundColor(Default.majorColor)
                                                Image(systemName: "multiply.square.fill")
                                                    .foregroundColor(Default.majorColor)
                                                Image(systemName: "plus.square.fill")
                                                    .foregroundColor(Default.majorColor)
                                                Image(systemName: "greaterthan.square")
                                                    .foregroundColor(Default.majorColor)
                                            }
                                        }
                                    }
                                }
                                Button {
                                    initSequencer(nowPlaying: HStack {
                                        Text("Locrian")
                                            .foregroundColor(Default.minorColor)
                                        HStack(spacing: 0) {
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "i.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "lessthan.square")
                                                .foregroundColor(Default.minorColor)
                                        }
                                    }, filename: "locrian", songTonic: 47, itemID: 19)
                                    viewConductor.setPitchMovement(false)
                                    if viewConductor.gridLayoutKeysPerRow < 17 {viewConductor.gridLayoutKeysPerRow = 17}
                                    dismiss()
                                } label: {
                                    ZStack {
                                        if self.scrollToID == 19 { Default.highlightGray }
                                        HStack {
                                            Text("Locrian")
                                                .foregroundColor(Default.minorColor)
                                                .underline()
                                                .id(19)
                                            Spacer()
                                            HStack(spacing: 0) {
                                                Image(systemName: "minus.square.fill")
                                                    .foregroundColor(Default.minorColor)
                                                Image(systemName: "i.square.fill")
                                                    .foregroundColor(Default.minorColor)
                                                Image(systemName: "minus.square.fill")
                                                    .foregroundColor(Default.minorColor)
                                                Image(systemName: "lessthan.square")
                                                    .foregroundColor(Default.minorColor)
                                            }
                                        }
                                    }
                                }
                                Button {
                                    initSequencer(nowPlaying: HStack {
                                        Text("Awesome")
                                            .foregroundColor(Default.majorColor)
                                        HStack(spacing: 0) {
                                            Image(systemName: "plus.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "plus.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "plus.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "greaterthan.square")
                                                .foregroundColor(Default.majorColor)
                                        }
                                    }, filename: "awesome", songTonic: 48, itemID: 20)
                                    viewConductor.setPitchMovement(true)
                                    if viewConductor.gridLayoutKeysPerRow < 21 {viewConductor.gridLayoutKeysPerRow = 21}
                                    dismiss()
                                } label: {
                                    ZStack {
                                        if self.scrollToID == 20 { Default.highlightGray }
                                        HStack {
                                            Text("Awesome")
                                                .foregroundColor(Default.majorColor)
                                                .underline()
                                                .id(20)
                                            Spacer()
                                            HStack(spacing: 0) {
                                                Image(systemName: "plus.square.fill")
                                                    .foregroundColor(Default.majorColor)
                                                Image(systemName: "plus.square.fill")
                                                    .foregroundColor(Default.majorColor)
                                                Image(systemName: "minus.square.fill")
                                                    .foregroundColor(Default.minorColor)
                                                Image(systemName: "plus.square.fill")
                                                    .foregroundColor(Default.majorColor)
                                                Image(systemName: "greaterthan.square")
                                                    .foregroundColor(Default.majorColor)
                                            }
                                        }
                                    }
                                }
                                Button {
                                    initSequencer(nowPlaying: HStack {
                                        Text("Awesome (mirror)")
                                            .foregroundColor(Default.minorColor)
                                        HStack(spacing: 0) {
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "plus.square.fill")
                                                .foregroundColor(Default.majorColor)
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(Default.minorColor)
                                            Image(systemName: "lessthan.square")
                                                .foregroundColor(Default.minorColor)
                                        }
                                    }, filename: "mirror_awesome", songTonic: 52, itemID: 21)
                                    viewConductor.setPitchMovement(true)
                                    if viewConductor.gridLayoutKeysPerRow < 21 {viewConductor.gridLayoutKeysPerRow = 21}
                                    dismiss()
                                } label: {
                                    ZStack {
                                        if self.scrollToID == 21 { Default.highlightGray }
                                        HStack {
                                            Text("Awesome (mirror)")
                                                .foregroundColor(Default.minorColor)
                                                .underline()
                                                .id(21)
                                            Spacer()
                                            HStack(spacing: 0) {
                                                Image(systemName: "minus.square.fill")
                                                    .foregroundColor(Default.minorColor)
                                                Image(systemName: "minus.square.fill")
                                                    .foregroundColor(Default.minorColor)
                                                Image(systemName: "plus.square.fill")
                                                    .foregroundColor(Default.majorColor)
                                                Image(systemName: "minus.square.fill")
                                                    .foregroundColor(Default.minorColor)
                                                Image(systemName: "lessthan.square")
                                                    .foregroundColor(Default.minorColor)
                                            }
                                        }
                                    }
                                }

                            }
                        }
                    }
                    .onAppear() {
                        proxy.scrollTo(scrollToID, anchor: .center)
                    }
                    .onDisappear() {
                        scrollToID = 0
                    }
                }
                .padding([.trailing, .leading, .bottom], 10)
            } // ScrollView
        }
    }
}
