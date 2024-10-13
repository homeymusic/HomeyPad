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
        
        // Instrument Settings ~ Start

        instrument.masterVolume = 0.8
        instrument.pitchBend = 0

        instrument.attackDuration = 0.02
        instrument.filterAttackDuration = 0.1

        instrument.decayDuration = 1.5
        instrument.filterDecayDuration = 0.4

        instrument.sustainLevel = 0.1
        instrument.filterSustainLevel = 0.05

        instrument.releaseDuration = 0.8
        instrument.filterReleaseDuration = 0.3

        instrument.filterCutoff = 4.0
        instrument.filterResonance = -1.0
        instrument.filterStrength = 0.2
        
        instrument.vibratoDepth = 0.03
        
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
