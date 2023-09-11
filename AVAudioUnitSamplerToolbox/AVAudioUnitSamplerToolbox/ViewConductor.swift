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
    
    init() {
        defaults.register(defaults: ["octaveCount": 1])
        octaveCount = defaults.integer(forKey: "octaveCount")

        // Start the engine
        conductor.start()
        
        // Set up MIDI
        MIDIConnect()        
    }
    
    //Keyboard Events
    func noteOn(pitch: Pitch, point: CGPoint) {
        // TODO: make vertical velocity an option?
        // conductor.instrument.startNote(UInt8(pitch.intValue), withVelocity: UInt8(point.y * 127), onChannel: 0)
        conductor.instrument.startNote(UInt8(pitch.intValue), withVelocity: conductor.velocity, onChannel: 0)
    }
    
    func noteOff(pitch: Pitch) {
        conductor.instrument.stopNote(UInt8(pitch.intValue), onChannel: 0)
    }
    
    func updateMIDIFilter(Param: AUValue, knobNumber: Int){
        if knobNumber == 1 {
            conductor.reverb.wetDryMix = Param
        } else if knobNumber == 2 {
            conductor.delay.wetDryMix = Param
        } else if knobNumber == 3 {
            conductor.delay.delayTime = TimeInterval(Param)
        } else if knobNumber == 4 {
            conductor.lowPassCutoff = Param
        } else if knobNumber == 5 {
            conductor.velocity = UInt8(Param)
        } else if knobNumber == 6 {
            conductor.instrument.overallGain = Param
        } else if knobNumber == 7 {
            octaveCount = Int(Param)
            defaults.set(octaveCount, forKey: "octaveCount")
        }
    }
}

extension NSNotification.Name {
    static let keyNoteOn = Notification.Name("keyNoteOn")
    static let keyNoteOff = Notification.Name("keyNoteOff")
    static let knobUpdate = Notification.Name("knobUpdate")
    static let MIDIKey = Notification.Name("MIDIKey")
}
