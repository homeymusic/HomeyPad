import AVFoundation
import Tonic
import MIDIKit
import Foundation

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
    
    @Published var octaveCount: Int
    @Published var keysPerRow: Int
    @Published var tonicSelector: Bool
    @Published var tonicPitchClass: Int

    init() {
        defaults.register(defaults: ["octaveCount": 1, "tonicSelector": false, "keysPerRow": 13])
        octaveCount = defaults.integer(forKey: "octaveCount")
        keysPerRow = defaults.integer(forKey: "keysPerRow")
        tonicSelector = defaults.bool(forKey: "tonicSelector")
        tonicPitchClass = defaults.integer(forKey: "tonicPitchClass")

        // Start the engine
        conductor.start()
        
        // Set up MIDI
        MIDIConnect()        
    }
    
    //Keyboard Events
    func noteOn(pitch: Pitch, point: CGPoint) {
        conductor.instrument.startNote(UInt8(pitch.intValue), withVelocity: 63, onChannel: 0)
    }
    
    func noteOff(pitch: Pitch) {
        conductor.instrument.stopNote(UInt8(pitch.intValue), onChannel: 0)
    }
    
    func selectTonic(pitch: Pitch, point: CGPoint) {
        print("pitch \(pitch) pitch class \(pitch.intValue % 12)")
        self.tonicPitchClass = pitch.intValue % 12
    }
    
    func updateMIDIFilter(Param: AUValue, knobNumber: Int){
    }
}

extension NSNotification.Name {
    static let keyNoteOn = Notification.Name("keyNoteOn")
    static let keyNoteOff = Notification.Name("keyNoteOff")
    static let MIDIKey = Notification.Name("MIDIKey")
}
