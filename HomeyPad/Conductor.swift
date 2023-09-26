import AVFoundation
import AudioKit

class Conductor: ObservableObject {
    // Audio Engine
    let engine = AudioEngine()
    
    // Sampler Instrument
    var instrument = MIDISampler()
    
    init() {
        
        // Attach Nodes to the Engine
        engine.output = instrument
        
        // Load AVAudioUnitSampler Instrument
        try? instrument.loadInstrument(at: Bundle.main.url(forResource: "Sounds/YDP-GrandPiano-20160804", withExtension: "sf2")!)
        
    }
    
    func start() {
        try? engine.start()
    }
}
