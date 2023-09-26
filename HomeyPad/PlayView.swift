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
    
    var midiCallback = MIDICallbackInstrument()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Example Tunes")
                    .font(.headline)
                Spacer()
            }
            .padding(.top, 10)
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    Group {
                        HStack {
                            Text("Example Melodies")
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        Button {
                            let filename: String = "twinkle_twinkle_little_star"
                            let songTonic: Int = 48
                            let title = HStack(spacing: 4) {
                                Text("Twinkle Twinkle Little Star")
                                    .foregroundColor(Default.majorColor)
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
                                }
                            }
                            viewConductor.keysPerRow = 13
                            viewConductor.octaveCount = 1
                            dismiss()
                            midiPlayer.load(nowPlaying: title, filename: filename, songTonic: songTonic, keyboardTonic: self.viewConductor.tonicPitchClass, instrument: self.viewConductor.conductor.instrument)
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
                            let filename: String = "seven_nation_army"
                            let songTonic: Int = 52
                            let title = HStack(spacing: 4) {
                                Text("Seven Nation Army")
                                    .foregroundColor(Default.minorColor)
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "lessthan.square")
                                        .foregroundColor(Default.minorColor)
                                }
                            }
                            viewConductor.keysPerRow = 13
                            viewConductor.octaveCount = 1
                            dismiss()
                            midiPlayer.load(nowPlaying: title, filename: filename, songTonic: songTonic, keyboardTonic: self.viewConductor.tonicPitchClass, instrument: self.viewConductor.conductor.instrument)
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
                            let filename: String = "happy_birthday"
                            let songTonic: Int = 60
                            let title = HStack(spacing: 4) {
                                Text("Happy Birthday")
                                    .foregroundColor(Default.majorColor)
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
                                }
                            }
                            viewConductor.keysPerRow = 23
                            viewConductor.octaveCount = 1
                            dismiss()
                            midiPlayer.load(nowPlaying: title, filename: filename, songTonic: songTonic, keyboardTonic: self.viewConductor.tonicPitchClass, instrument: self.viewConductor.conductor.instrument)
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
                            let filename: String = "may_your_soul_rest"
                            let songTonic: Int = 52
                            let title = HStack(spacing: 4) {
                                Text("May Your Soul Rest")
                                    .foregroundColor(Default.minorColor)
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "lessthan.square")
                                        .foregroundColor(Default.minorColor)
                                }
                            }
                            viewConductor.keysPerRow = 23
                            viewConductor.octaveCount = 1
                            dismiss()
                            midiPlayer.load(nowPlaying: title, filename: filename, songTonic: songTonic, keyboardTonic: self.viewConductor.tonicPitchClass, instrument: self.viewConductor.conductor.instrument)
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
                    }
                    Divider()
                        .padding(5)
                    Group {
                        HStack {
                            Text("Example Harmonies")
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        Button {
                            print("play example")
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
                            print("play example")
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
                            print("play example")
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
                            print("play example")
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
                            print("play example")
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
                            print("play example")
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
                            print("play example")
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
                        Button {
                            print("play example")
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
                            print("play example")
                        } label: {
                            HStack {
                                Text("Locrian")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "multiply.square.fill")
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
                .padding([.trailing, .leading, .bottom], 10)
            } // ScrollView
        }
    }
}
