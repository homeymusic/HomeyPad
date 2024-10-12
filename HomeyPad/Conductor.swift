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
        
        instrument.attackDuration = 0.01        // Fast attack for a plucky sound
        instrument.decayDuration = 0.2          // Short decay to shape the pluck effect
        instrument.sustainLevel = 0.8           // Sustain level to keep sound playing while the note is held
        instrument.releaseDuration = 0.1        // Short release to stop sound quickly after key release

        instrument.filterCutoff = 1.5           // Filter cutoff just above the fundamental frequency
        instrument.filterStrength = 0.5         // Small modulation for movement in filter
        instrument.filterResonance = 10.0       // Moderate resonance for a sharper sound

        instrument.filterAttackDuration = 0.01  // Fast filter attack to match pluckiness
        instrument.filterDecayDuration = 0.2    // Short filter decay to match the amplitude decay
        instrument.filterSustainLevel = 0.8     // Sustain to maintain brightness while note is held
        instrument.filterReleaseDuration = 0.1  // Short filter release to stop sound quickly
        
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
