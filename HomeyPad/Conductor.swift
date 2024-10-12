import AVFoundation
import AudioKit
import DunneAudioKit
import HomeyMusicKit

class Conductor: ObservableObject {
    let engine = AudioEngine()
    var instrument = Synth()
    
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

        engine.output = PeakLimiter(instrument, attackTime: 0.001, decayTime: 0.001, preGain: 0)
        
        instrument.releaseDuration = 0.01
        instrument.filterReleaseDuration = 10.0
        instrument.filterStrength = 40.0

        start()
    }
    
    func start() {
        try? engine.start()
    }
    
    func noteOn(pitch: Pitch) {
        instrument.play(noteNumber: UInt8(pitch.midi), velocity: 64, channel: 0)
    }
    
    func noteOff(pitch: Pitch) {
        instrument.stop(noteNumber: UInt8(pitch.midi), channel: 0)
    }
    
}
