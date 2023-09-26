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
    var sequencer: AppleSequencer  = AppleSequencer()
    
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
