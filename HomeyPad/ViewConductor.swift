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
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    @Published var octaveCount: Int {
        didSet {
            defaults.set(self.octaveCount, forKey: "octaveCount")
            if oldValue != self.octaveCount {self.simpleSuccess()}
        }
    }
    @Published var keysPerRow: Int {
        didSet {
            defaults.set(self.keysPerRow, forKey: "keysPerRow")
            if oldValue != self.keysPerRow {self.simpleSuccess()}
        }
    }
    @Published var showSelector: Bool {
        didSet {
            defaults.set(self.showSelector, forKey: "showSelector")
            if oldValue != self.showSelector {self.simpleSuccess()}
        }
    }
    @Published var showClassicalSelector: Bool {
        didSet {
            defaults.set(self.showClassicalSelector, forKey: "showClassicalSelector")
            if oldValue != self.showClassicalSelector {self.simpleSuccess()}
        }
    }
    @Published var showIntegersSelector: Bool {
        didSet {
            defaults.set(self.showIntegersSelector, forKey: "showIntegersSelector")
            if oldValue != self.showIntegersSelector {self.simpleSuccess()}
        }
    }
    @Published var showMonthsSelector: Bool {
        didSet {
            defaults.set(self.showMonthsSelector, forKey: "showMonthsSelector")
            if oldValue != self.showMonthsSelector {self.simpleSuccess()}
        }
    }
    @Published var showPianoSelector: Bool {
        didSet {
            defaults.set(self.showPianoSelector, forKey: "showPianoSelector")
            if oldValue != self.showPianoSelector {self.simpleSuccess()}
        }
    }
    @Published var showIntervals: Bool {
        didSet {
            defaults.set(self.showIntervals, forKey: "showIntervals")
            if oldValue != self.showIntervals {self.simpleSuccess()}
        }
    }
    @Published var showModes: Bool {
        didSet {
            defaults.set(self.showModes, forKey: "showModes")
            if oldValue != self.showModes {self.simpleSuccess()}
        }
    }
    @Published var tonicPitchClass: Int {
        didSet {
            defaults.set(self.tonicPitchClass, forKey: "tonicPitchClass")
            if oldValue != self.tonicPitchClass {self.simpleSuccess()}
        }
    }
    @Published var upwardPitchMovement: Bool {
        didSet {
            defaults.set(self.upwardPitchMovement, forKey: "upwardPitchMovement")
            if oldValue != self.upwardPitchMovement {self.simpleSuccess()}
        }
    }
    @Published var nowPlayingTitle: any View = Text("")
    @Published var nowPlayingID: Int = 0
    @Published var scrollToID: Int = 0

    init() {
        defaults.register(defaults: ["octaveCount": Default.octaveCount, "showClassicalSelector": Default.showClassicalSelector, "showIntegersSelector": Default.showIntegersSelector, "showMonthsSelector": Default.showMonthsSelector, "showPianoSelector": Default.showPianoSelector, "showIntervals": Default.showIntervals, "showModes": Default.showModes, "keysPerRow": Default.keysPerRow, "tonicPitchClass": Default.tonicPitchClass,
                                     "upwardPitchMovement": Default.upwardPitchMovement])
        octaveCount = defaults.integer(forKey: "octaveCount")
        keysPerRow = defaults.integer(forKey: "keysPerRow")
        showSelector = defaults.bool(forKey: "showSelector")
        showClassicalSelector = defaults.bool(forKey: "showClassicalSelector")
        showIntegersSelector = defaults.bool(forKey: "showIntegersSelector")
        showMonthsSelector = defaults.bool(forKey: "showMonthsSelector")
        showPianoSelector = defaults.bool(forKey: "showPianoSelector")
        showIntervals  = defaults.bool(forKey: "showIntervals")
        showModes  = defaults.bool(forKey: "showModes")
        tonicPitchClass = defaults.integer(forKey: "tonicPitchClass")
        upwardPitchMovement = defaults.bool(forKey: "upwardPitchMovement")
        
        // Start the engine
        conductor.start()
        
        // Set up MIDI
        MIDIConnect()
    }
    
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
