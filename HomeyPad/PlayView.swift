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
    let midiPlayer: MIDIPlayer
    
    func initSequencer(nowPlaying: any View, filename: String, songTonic: Int) {
        midiPlayer.stop()
        let midiCallback = MIDICallbackInstrument()
        
        self.midiPlayer.nowPlaying = nowPlaying
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
                            }, filename: "twinkle_twinkle_little_star", songTonic: 48)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Twinkle Twinkle Little Star")
                                    .foregroundColor(Default.majorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
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
                            }, filename: "pulsing_pulsing_neutron_star", songTonic: 40)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Pulsing Pulsing Neutron Star")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "lessthan.square")
                                        .foregroundColor(Default.minorColor)
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
                            }, filename: "seven_princess_party", songTonic: 60)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Seven Princess Party")
                                    .foregroundColor(Default.majorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
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
                            }, filename: "seven_nation_army", songTonic: 52)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Seven Nation Army")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "lessthan.square")
                                        .foregroundColor(Default.minorColor)
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
                            }, filename: "happy_birthday", songTonic: 60)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Happy Birthday")
                                    .foregroundColor(Default.majorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
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
                            }, filename: "may_your_soul_rest", songTonic: 52)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("May Your Soul Rest")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "lessthan.square")
                                        .foregroundColor(Default.minorColor)
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
                            }, filename: "somewhere_over_the_rainbow", songTonic: 48)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Somewhere Over the Rainbow")
                                    .foregroundColor(Default.majorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
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
                                }, filename: "nature_boy", songTonic: 57)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Nature Boy")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
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
                            }, filename: "ionian", songTonic: 48)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Ionian (Major)")
                                    .foregroundColor(Default.majorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
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
                            }, filename: "phrygian", songTonic: 52)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Phrygian")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "lessthan.square")
                                        .foregroundColor(Default.minorColor)
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
                            }, filename: "mixolydian", songTonic: 55)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Mixolydian")
                                    .foregroundColor(Default.majorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "lessthan.square")
                                        .foregroundColor(Default.minorColor)
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
                                }, filename: "aeolian", songTonic: 69)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Aeolian (Natural Minor)")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
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
                                }, filename: "harmonic_minor", songTonic: 69)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Harmonic Minor")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
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
                            }, filename: "dorian_down", songTonic: 50)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Dorian Down")
                                    .foregroundColor(Default.majorColor)
                                    .underline()
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
                                }, filename: "dorian_up", songTonic: 62)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Dorian Up")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
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
                                }, filename: "lydian", songTonic: 65)
                                midiPlayer.play()
                            } label: {
                                HStack {
                                    Text("Lydian")
                                        .foregroundColor(Default.majorColor)
                                        .underline()
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
                                }, filename: "locrian", songTonic: 47)
                                midiPlayer.play()
                            } label: {
                                HStack {
                                    Text("Locrian")
                                        .foregroundColor(Default.minorColor)
                                        .underline()
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
                .padding([.trailing, .leading, .bottom], 10)
            } // ScrollView
        }
    }
}
