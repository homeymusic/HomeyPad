//
//  MIDIPlayer.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 9/26/23.
//
import Foundation
import SwiftUI
import AudioKit

class MIDIPlayer: ObservableObject {
    @Published var state: PlayerState = .stopped
    @Published var nowPlaying: any View = Text("")
    private let sequencer: AppleSequencer  = AppleSequencer()
    private let midiCallback = MIDICallbackInstrument()
    
    init() {
    }
    
    func load(nowPlaying: any View, filename: String, songTonic: Int, keyboardTonic: Int, instrument: AppleSampler) {
        self.nowPlaying = nowPlaying
        midiCallback.callback = { status, note, velocity in
            let midiNote = UInt8(Default.initialC - songTonic + keyboardTonic + Int(note))
            if status == 144 {
                instrument.play(noteNumber: midiNote, velocity: 127, channel: 0)
                NotificationCenter.default.post(name: .MIDIKey, object: nil, userInfo: ["info": midiNote, "bool": true])
            } else if status == 128 {
                instrument.stop(noteNumber: midiNote, channel: 0)
                NotificationCenter.default.post(name: .MIDIKey, object: nil, userInfo: ["info": midiNote, "bool": false])
            }
        }
        sequencer.loadMIDIFile(fromURL: Bundle.main.url(forResource: filename, withExtension: "mid", subdirectory: "Examples")!)
        self.sequencer.setGlobalMIDIOutput(midiCallback.midiIn)
        self.sequencer.enableLooping()
    }
    
    func play()
    {
        self.sequencer.play()
        self.state = .playing
    }
    
    func pause()
    {
        self.sequencer.stop()
        self.state = .paused
    }
    
    func stop()
    {
        self.sequencer.stop()
        self.sequencer.rewind()
        self.state = .stopped
    }
    func rewind()
    {
        self.sequencer.rewind()
    }
}
