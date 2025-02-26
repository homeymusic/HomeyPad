import MIDIKit
import AVFoundation
import AudioKit
import DunneAudioKit
import HomeyMusicKit

class SynthConductor: ObservableObject {
    let engine = AudioEngine()
    var instrument = Synth()
    
    init() {
        configureAudioSession()
        addObservers()
        engine.output = PeakLimiter(instrument, attackTime: 0.001, decayTime: 0.001, preGain: 0)
        configureInstrument()
        start()
    }
    
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
    
    func start() {
        do {
            try engine.start()
        } catch {
            print("Error starting the engine: \(error)")
        }
    }
    
    func noteOn(pitch: Pitch) {
        instrument.play(noteNumber: UInt8(pitch.midiNote.number), velocity: 64, channel: 0)
    }
    
    func noteOff(pitch: Pitch) {
        instrument.stop(noteNumber: UInt8(pitch.midiNote.number), channel: 0)
    }
    
    private func configureInstrument() {
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
    }
    
    func reloadAudio() {
        // Reload audio engine if necessary
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !self.engine.avEngine.isRunning {
                self.start()
            }
        }
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleRouteChange), name: AVAudioSession.routeChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    @objc func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt else { return }
        
        switch reason {
        case AVAudioSession.RouteChangeReason.newDeviceAvailable.rawValue:
            reloadAudio()
        case AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue:
            reloadAudio()
        default:
            break
        }
    }
    
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        if type == .began {
            engine.stop()
        } else if type == .ended {
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {
                return
            }
            if AVAudioSession.InterruptionOptions(rawValue: optionsValue).contains(.shouldResume) {
                reloadAudio()
            }
        }
    }
}
