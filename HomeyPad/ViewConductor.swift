import AVFoundation
import Tonic
import MIDIKit
import Foundation
import SwiftUI

class ViewConductor: ObservableObject {
    // Audio Engine
    var conductor = Conductor()
    let defaults = UserDefaults.standard
    
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
    @Published var showHomeySelector: Bool {
        didSet {
            defaults.set(self.showHomeySelector, forKey: "showHomeySelector")
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
        defaults.register(defaults: ["octaveCount": Default.octaveCount, "showClassicalSelector": Default.showClassicalSelector, "showHomeySelector": Default.showHomeySelector, "showPianoSelector": Default.showPianoSelector, "showIntervals": Default.showIntervals, "keysPerRow": Default.keysPerRow, "tonicPitchClass": Default.tonicPitchClass])
        octaveCount = defaults.integer(forKey: "octaveCount")
        keysPerRow = defaults.integer(forKey: "keysPerRow")
        showClassicalSelector = defaults.bool(forKey: "showClassicalSelector")
        showHomeySelector = defaults.bool(forKey: "showHomeySelector")
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
        conductor.instrument.startNote(UInt8(pitch.intValue), withVelocity: 127, onChannel: 0)
    }
    
    func noteOff(pitch: Pitch) {
        conductor.instrument.stopNote(UInt8(pitch.intValue), onChannel: 0)
    }
    
    func selectTonic(pitch: Pitch, point: CGPoint) {
        if (pitch.intValue % 12 != self.tonicPitchClass) {
            self.tonicPitchClass = pitch.intValue % 12
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
