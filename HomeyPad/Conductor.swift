import AVFoundation

class Conductor: ObservableObject {
    let engine = AVAudioEngine()
    var instrument = AVAudioUnitSampler()
    
    func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // Set the category to allow mixing with other audio
            try audioSession.setCategory(.playback, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }
    
    init() {
        configureAudioSession()
        engine.attach(instrument)
        engine.connect(instrument, to: engine.mainMixerNode, format: nil)
        start()
    }
    
    func start() {
        try? instrument.loadInstrument(at: Bundle.main.url(forResource: "Sounds/YDP-GrandPiano-20160804", withExtension: "exs")!)
        try? engine.start()
    }
    
    func noteOn(pitch: Pitch) {
        instrument.startNote(UInt8(pitch.midi), withVelocity: 64, onChannel: 0)
    }
    
    func noteOff(pitch: Pitch) {
        instrument.stopNote(UInt8(pitch.midi), onChannel: 0)
    }
    
}
