//
//  SettingsView.swift
//
//  Created by Brian McAuliff Mulloy on 9/12/23.
//

import SwiftUI

struct PlayView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Play")
                    .font(.headline)
                Spacer()
            }
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    Group {
                        HStack {
                            Spacer()
                            Text("Example Melodies")
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        Button {
                            print("play example")
                        } label: {
                            HStack {
                                Text("Twinkle Twinkle Little Star")
                                    .foregroundColor(Default.majorColor)
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
                                Text("Seven Nation Army")
                                    .foregroundColor(Default.minorColor)
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
                                Text("Happy Birthday")
                                    .foregroundColor(Default.majorColor)
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
                                Text("May Your Soul Rest")
                                    .foregroundColor(Default.minorColor)
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
                            Spacer()
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
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.tritoneColor)
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
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.tritoneColor)
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
        .padding()
    }
}


struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
    }
}
