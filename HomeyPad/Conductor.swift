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
        
        instrument.pitchBend = 0

        // Instrument Settings ~ Start
        
        instrument.attackDuration = 0.03        // Slightly faster attack for a more playful, immediate sound
        instrument.decayDuration = 0.2          // Short decay to keep the plucky character
        instrument.sustainLevel = 0.5           // Moderate sustain to hold the playful tone
        instrument.releaseDuration = 0.3        // Shorter release to make the sound snappier

        instrument.filterCutoff = 1.6           // Higher cutoff to brighten the sound and reduce underwater effect
        instrument.filterStrength = 0.3         // Slight modulation to keep some movement
        instrument.filterResonance = 3.0        // Lower resonance to avoid harsh metallic quality

        instrument.filterAttackDuration = 0.03  // Fast attack to match playful tone
        instrument.filterDecayDuration = 0.2    // Short decay for snappy character
        instrument.filterSustainLevel = 0.5     // Moderate sustain to hold the tone
        instrument.filterReleaseDuration = 0.3  // Shorter release to match amplitude release

        instrument.vibratoDepth = 0.05          // Gentle vibrato for light movement, playful feel

        // Instrument Settings ~ Stop

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
