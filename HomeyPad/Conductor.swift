import AVFoundation

class Conductor: ObservableObject {
    // Audio Engine
    let engine = AVAudioEngine()
    
    // Sampler Instrument
    var instrument = AVAudioUnitSampler()
    
    init() {
        // Attach Nodes to the Engine
        engine.attach(instrument)
        
        // Connect Nodes to the Engine's output
        engine.connect(instrument, to: engine.mainMixerNode, format: nil)
        
        // Load AVAudioUnitSampler Instrument
        try? instrument.loadInstrument(at: Bundle.main.url(forResource: "Sounds/YDP-GrandPiano-20160804", withExtension: "sf2")!)
        
    }
    
    func start() {
        try? engine.start()
    }
}
