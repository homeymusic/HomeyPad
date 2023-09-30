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
            let midiNote: UInt8 = UInt8(Default.initialC - songTonic + viewConductor.tonicPitchClass + Int(note))
            if status == 144 {
                viewConductor.playNote(midiNote)
            } else if status == 128 {
                viewConductor.stopNote(midiNote)
            }
        }
        midiPlayer.sequencer.loadMIDIFile(fromURL: Bundle.main.url(forResource: filename, withExtension: "mid", subdirectory: "Examples")!)
        midiPlayer.sequencer.setGlobalMIDIOutput(midiCallback.midiIn)
        midiPlayer.sequencer.enableLooping()
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
                                dismiss()
                                viewConductor.keysPerRow = 13
                                viewConductor.octaveCount = 1
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
                                midiPlayer.play()
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
                                dismiss()
                                viewConductor.keysPerRow = 13
                                viewConductor.octaveCount = 1
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Pulsing Pulsing Neutron Star")
                                        .foregroundColor(Default.minorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "minus.square.fill")
                                            .foregroundColor(Default.minorColor)
                                        Image(systemName: "lessthan.square")
                                            .foregroundColor(Default.minorColor)
                                    }
                                }, filename: "pulsing_pulsing_neutron_star", songTonic: 40, itemID: 2)
                                midiPlayer.play()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 2 { Default.highlightGray }
                                    HStack {
                                        Text("Pulsing Pulsing Neutron Star")
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
                                dismiss()
                                viewConductor.keysPerRow = 13
                                viewConductor.octaveCount = 1
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Seven Princess Party")
                                        .foregroundColor(Default.majorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "plus.square.fill")
                                            .foregroundColor(Default.majorColor)
                                        Image(systemName: "greaterthan.square")
                                            .foregroundColor(Default.majorColor)
                                    }
                                }, filename: "seven_princess_party", songTonic: 60, itemID: 3)
                                midiPlayer.play()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 3 { Default.highlightGray }
                                    
                                    HStack {
                                        Text("Seven Princess Party")
                                            .foregroundColor(Default.majorColor)
                                            .underline()
                                            .id(3)
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
                                dismiss()
                                viewConductor.keysPerRow = 13
                                viewConductor.octaveCount = 1
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Seven Nation Army")
                                        .foregroundColor(Default.minorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "minus.square.fill")
                                            .foregroundColor(Default.minorColor)
                                        Image(systemName: "lessthan.square")
                                            .foregroundColor(Default.minorColor)
                                    }
                                }, filename: "seven_nation_army", songTonic: 52, itemID: 4)
                                midiPlayer.play()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 4 { Default.highlightGray }
                                    HStack {
                                        Text("Seven Nation Army")
                                            .foregroundColor(Default.minorColor)
                                            .underline()
                                            .id(4)
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
                                dismiss()
                                viewConductor.keysPerRow = 23
                                viewConductor.octaveCount = 1
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Happy Birthday")
                                        .foregroundColor(Default.majorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "plus.square.fill")
                                            .foregroundColor(Default.majorColor)
                                        Image(systemName: "greaterthan.square")
                                            .foregroundColor(Default.majorColor)
                                    }
                                }, filename: "happy_birthday", songTonic: 60, itemID: 5)
                                midiPlayer.play()
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
                                            Image(systemName: "greaterthan.square")
                                                .foregroundColor(Default.majorColor)
                                        }
                                    }
                                }
                            }
                            Button {
                                dismiss()
                                viewConductor.keysPerRow = 23
                                viewConductor.octaveCount = 1
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("May Your Soul Rest")
                                        .foregroundColor(Default.minorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "minus.square.fill")
                                            .foregroundColor(Default.minorColor)
                                        Image(systemName: "lessthan.square")
                                            .foregroundColor(Default.minorColor)
                                    }
                                }, filename: "may_your_soul_rest", songTonic: 52, itemID: 6)
                                midiPlayer.play()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 6 { Default.highlightGray }
                                    HStack {
                                        Text("May Your Soul Rest")
                                            .foregroundColor(Default.minorColor)
                                            .underline()
                                            .id(6)
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
                                dismiss()
                                viewConductor.keysPerRow = 19
                                viewConductor.octaveCount = 1
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Somewhere Over the Rainbow")
                                        .foregroundColor(Default.majorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "plus.square.fill")
                                            .foregroundColor(Default.majorColor)
                                        Image(systemName: "greaterthan.square")
                                            .foregroundColor(Default.majorColor)
                                    }
                                }, filename: "somewhere_over_the_rainbow", songTonic: 48, itemID: 7)
                                midiPlayer.play()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 7 { Default.highlightGray }
                                    HStack {
                                        Text("Somewhere Over the Rainbow")
                                            .foregroundColor(Default.majorColor)
                                            .underline()
                                            .id(7)
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
                                dismiss()
                                viewConductor.keysPerRow = 23
                                viewConductor.octaveCount = 1
                                initSequencer(nowPlaying:
                                                HStack {
                                    Text("Nature Boy")
                                        .foregroundColor(Default.minorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "paintpalette")
                                            .symbolRenderingMode(.multicolor)
                                        Image(systemName: "minus.square.fill")
                                            .foregroundColor(Default.minorColor)
                                        Image(systemName: "greaterthan.square")
                                            .foregroundColor(Default.majorColor)
                                    }
                                }, filename: "nature_boy", songTonic: 57, itemID: 8)
                                midiPlayer.play()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 8 { Default.highlightGray }
                                    HStack {
                                        Text("Nature Boy")
                                            .foregroundColor(Default.minorColor)
                                            .underline()
                                            .id(8)
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
                                dismiss()
                                if  formFactor() == .iPad {
                                    viewConductor.keysPerRow = maxKeysPerRow()
                                    viewConductor.octaveCount = 1
                                } else {
                                    viewConductor.keysPerRow = minKeysPerRow()
                                    viewConductor.octaveCount = 5
                                }
                                initSequencer(nowPlaying:
                                                HStack {
                                    Text("J.S. Bach Italian Concerto BWV 971")
                                        .foregroundColor(Default.minorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "plus.square.fill")
                                            .foregroundColor(Default.majorColor)
                                        Image(systemName: "greaterthan.square")
                                            .foregroundColor(Default.majorColor)
                                    }
                                }, filename: "bach_italian_concerto", songTonic: 53, itemID: 9)
                                midiPlayer.play()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 9 { Default.highlightGray }
                                    HStack {
                                        Text("J.S. Bach Italian Concerto BWV 971")
                                            .foregroundColor(Default.minorColor)
                                            .underline()
                                            .id(9)
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

                        }
                        Divider()
                            .padding(5)
                        Group {
                            HStack {
                                Text("Scales")
                                    .font(.subheadline)
                                Spacer()
                            }
                            .padding(.bottom, 5)
                            Button {
                                dismiss()
                                viewConductor.keysPerRow = 17
                                viewConductor.octaveCount = 1
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Ionian (Major)")
                                        .foregroundColor(Default.majorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "plus.square.fill")
                                            .foregroundColor(Default.majorColor)
                                        Image(systemName: "greaterthan.square")
                                            .foregroundColor(Default.majorColor)
                                    }
                                }, filename: "ionian", songTonic: 48, itemID: 10)
                                midiPlayer.play()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 10 { Default.highlightGray }
                                    HStack {
                                        Text("Ionian (Major)")
                                            .foregroundColor(Default.majorColor)
                                            .underline()
                                            .id(10)
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
                                dismiss()
                                viewConductor.keysPerRow = 17
                                viewConductor.octaveCount = 1
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Phrygian")
                                        .foregroundColor(Default.minorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "minus.square.fill")
                                            .foregroundColor(Default.minorColor)
                                        Image(systemName: "lessthan.square")
                                            .foregroundColor(Default.minorColor)
                                    }
                                }, filename: "phrygian", songTonic: 52, itemID: 11)
                                midiPlayer.play()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 11 { Default.highlightGray }
                                    HStack {
                                        Text("Phrygian")
                                            .foregroundColor(Default.minorColor)
                                            .underline()
                                            .id(11)
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
                                dismiss()
                                viewConductor.keysPerRow = 17
                                viewConductor.octaveCount = 1
                                initSequencer(nowPlaying: HStack(spacing: 4) {
                                    Text("Mixolydian")
                                        .foregroundColor(Default.majorColor)
                                    HStack(spacing: 0) {
                                        Image(systemName: "plus.square.fill")
                                            .foregroundColor(Default.majorColor)
                                        Image(systemName: "lessthan.square")
                                            .foregroundColor(Default.minorColor)
                                    }
                                }, filename: "mixolydian", songTonic: 55, itemID: 12)
                                midiPlayer.play()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 12 { Default.highlightGray }
                                    HStack {
                                        Text("Mixolydian")
                                            .foregroundColor(Default.majorColor)
                                            .underline()
                                            .id(12)
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
                                dismiss()
                                viewConductor.keysPerRow = 17
                                viewConductor.octaveCount = 1
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
                                }, filename: "aeolian", songTonic: 69, itemID: 13)
                                midiPlayer.play()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 13 { Default.highlightGray }
                                    HStack {
                                        Text("Aeolian (Natural Minor)")
                                            .foregroundColor(Default.minorColor)
                                            .underline()
                                            .id(13)
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
                                dismiss()
                                viewConductor.keysPerRow = 17
                                viewConductor.octaveCount = 1
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
                                }, filename: "harmonic_minor", songTonic: 69, itemID: 14)
                                midiPlayer.play()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 14 { Default.highlightGray }
                                    HStack {
                                        Text("Harmonic Minor")
                                            .foregroundColor(Default.minorColor)
                                            .underline()
                                            .id(14)
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
                                dismiss()
                                viewConductor.keysPerRow = 17
                                viewConductor.octaveCount = 1
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
                                }, filename: "dorian_down", songTonic: 50, itemID: 15)
                                midiPlayer.play()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 15 { Default.highlightGray }
                                    HStack {
                                        Text("Dorian Down")
                                            .foregroundColor(Default.majorColor)
                                            .underline()
                                            .id(15)
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
                                dismiss()
                                viewConductor.keysPerRow = 17
                                viewConductor.octaveCount = 1
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
                                }, filename: "dorian_up", songTonic: 62, itemID: 16)
                                midiPlayer.play()
                            } label: {
                                ZStack {
                                    if self.scrollToID == 16 { Default.highlightGray }
                                    HStack {
                                        Text("Dorian Up")
                                            .foregroundColor(Default.minorColor)
                                            .underline()
                                            .id(16)
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
                                    dismiss()
                                    viewConductor.keysPerRow = 17
                                    viewConductor.octaveCount = 1
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
                                    }, filename: "lydian", songTonic: 65, itemID: 17)
                                    midiPlayer.play()
                                } label: {
                                    ZStack {
                                        if self.scrollToID == 17 { Default.highlightGray }
                                        HStack {
                                            Text("Lydian")
                                                .foregroundColor(Default.majorColor)
                                                .underline()
                                                .id(17)
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
                                    dismiss()
                                    viewConductor.keysPerRow = 17
                                    viewConductor.octaveCount = 1
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
                                    }, filename: "locrian", songTonic: 47, itemID: 18)
                                    midiPlayer.play()
                                } label: {
                                    ZStack {
                                        if self.scrollToID == 18 { Default.highlightGray }
                                        HStack {
                                            Text("Locrian")
                                                .foregroundColor(Default.minorColor)
                                                .underline()
                                                .id(18)
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
