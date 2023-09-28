import AVFoundation
import Tonic
import MIDIKit
import Foundation
import SwiftUI

class ViewConductor: ObservableObject {
    // Audio Engine
    var conductor = Conductor()
    let defaults = UserDefaults.standard
    var notesPlaying = Set<UInt8>()
    
    // MIDI Manager (MIDI methods are in AVAudioUnitSampler+MIDI)
    let midiManager = MIDIManager(
        clientName: "HomeyPadMIDIManager",
        model: "HomeyPad",
        manufacturer: "HomeyMusic"
    )
    
    func playNote(_ midiNote: UInt8) {
        conductor.instrument.play(noteNumber: midiNote, velocity: 127, channel: 0)
        NotificationCenter.default.post(name: .MIDIKey, object: nil, userInfo: ["info": midiNote, "bool": true])
        notesPlaying.insert(midiNote)
    }
    
    func stopNote(_ midiNote: UInt8){
        conductor.instrument.stop(noteNumber: midiNote, channel: 0)
        NotificationCenter.default.post(name: .MIDIKey, object: nil, userInfo: ["info": midiNote, "bool": false])
        notesPlaying.remove(midiNote)
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    @Published var octaveCount: Int {
        didSet {
            defaults.set(self.octaveCount, forKey: "octaveCount")
            self.simpleSuccess()
        }
    }
    @Published var keysPerRow: Int {
        didSet {
            defaults.set(self.keysPerRow, forKey: "keysPerRow")
            self.simpleSuccess()
        }
    }
    @Published var showClassicalSelector: Bool {
        didSet {
            defaults.set(self.showClassicalSelector, forKey: "showClassicalSelector")
        }
    }
    @Published var showMonthsSelector: Bool {
        didSet {
            defaults.set(self.showMonthsSelector, forKey: "showMonthsSelector")
        }
    }
    @Published var showPianoSelector: Bool {
        didSet {
            defaults.set(self.showPianoSelector, forKey: "showPianoSelector")
        }
    }
    @Published var showIntervals: Bool {
        didSet {
            defaults.set(self.showIntervals, forKey: "showIntervals")
        }
    }
    @Published var tonicPitchClass: Int {
        
        didSet {
            defaults.set(self.tonicPitchClass, forKey: "tonicPitchClass")
            self.simpleSuccess()
        }
    }
    
    init() {
        defaults.register(defaults: ["octaveCount": Default.octaveCount, "showClassicalSelector": Default.showClassicalSelector, "showMonthsSelector": Default.showMonthsSelector, "showPianoSelector": Default.showPianoSelector, "showIntervals": Default.showIntervals, "keysPerRow": Default.keysPerRow, "tonicPitchClass": Default.tonicPitchClass])
        octaveCount = defaults.integer(forKey: "octaveCount")
        keysPerRow = defaults.integer(forKey: "keysPerRow")
        showClassicalSelector = defaults.bool(forKey: "showClassicalSelector")
        showMonthsSelector = defaults.bool(forKey: "showMonthsSelector")
        showPianoSelector = defaults.bool(forKey: "showPianoSelector")
        showIntervals  = defaults.bool(forKey: "showIntervals")
        tonicPitchClass = defaults.integer(forKey: "tonicPitchClass")
        
        // Start the engine
        conductor.start()
        
        // Set up MIDI
        MIDIConnect()
    }
    
    //Keyboard Events
    func noteOn(pitch: Pitch, point: CGPoint) {
        conductor.instrument.play(noteNumber: UInt8(pitch.intValue), velocity: 127, channel: 0)
    }
    
    func noteOff(pitch: Pitch) {
        conductor.instrument.stop(noteNumber: UInt8(pitch.intValue), channel: 0)
    }
    
    func resetNotes() {
        for midiNote in notesPlaying {
            stopNote(midiNote)
        }
    }
    
    func selectHome(pitchClass: Int, midiPlayer: MIDIPlayer) {
        let newPitchClass = mod(pitchClass, 12)
        if (newPitchClass != self.tonicPitchClass) {
            if (midiPlayer.state == .playing) {
                midiPlayer.pause()
                self.resetNotes()
                self.tonicPitchClass = newPitchClass
                midiPlayer.play()
            } else {
                self.tonicPitchClass = newPitchClass
            }
        }
    }    
    
    func updateMIDIFilter(Param: AUValue, knobNumber: Int){
    }
}

extension NSNotification.Name {
    static let keyNoteOn = Notification.Name("keyNoteOn")
    static let keyNoteOff = Notification.Name("keyNoteOff")
    static let MIDIKey = Notification.Name("MIDIKey")
}
