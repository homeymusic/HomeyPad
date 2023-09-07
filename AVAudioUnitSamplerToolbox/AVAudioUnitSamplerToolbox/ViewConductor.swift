import AVFoundation
import Tonic
import MIDIKit

class ViewConductor: ObservableObject {
    // Audio Engine
    var conductor = Conductor()
    
    // MIDI Manager (MIDI methods are in AVAudioUnitSampler+MIDI)
    let midiManager = MIDIManager(
        clientName: "HomeyPadMIDIManager",
        model: "HomeyPad",
        manufacturer: "HomeyMusic"
    )
    
    @Published var octaveCount: Int
    
    init() {
        octaveCount = 1

        // Start the engine
        conductor.start()
        
        // Set up MIDI
        MIDIConnect()        
    }
    
    //Keyboard Events
    func noteOn(pitch: Pitch, point: CGPoint) {
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
        }
    }
}

extension NSNotification.Name {
    static let keyNoteOn = Notification.Name("keyNoteOn")
    static let keyNoteOff = Notification.Name("keyNoteOff")
    static let knobUpdate = Notification.Name("knobUpdate")
    static let MIDIKey = Notification.Name("MIDIKey")
}
