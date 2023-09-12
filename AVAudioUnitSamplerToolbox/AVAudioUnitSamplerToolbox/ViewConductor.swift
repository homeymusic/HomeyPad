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

    init() {
        defaults.register(defaults: ["octaveCount": 3, "tonicSelector": false, "keysPerRow": 25])
        octaveCount = defaults.integer(forKey: "octaveCount")
        keysPerRow = defaults.integer(forKey: "keysPerRow")
        tonicSelector = defaults.bool(forKey: "tonicSelector")

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
    
    func updateMIDIFilter(Param: AUValue, knobNumber: Int){
    }
}

extension NSNotification.Name {
    static let keyNoteOn = Notification.Name("keyNoteOn")
    static let keyNoteOff = Notification.Name("keyNoteOff")
    static let MIDIKey = Notification.Name("MIDIKey")
}
