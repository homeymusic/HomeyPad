import AVFoundation
import AudioKit

class Conductor: ObservableObject {
    // Audio Engine
    let engine = AudioEngine()
    
    // Sampler Instrument
    var instrument = MIDISampler()
    var midiFile: AppleSequencer!
    var midiFileConnector: Node!
    
    init() {
        
        // Attach Nodes to the Engine
        engine.output = instrument
                
        // Load AVAudioUnitSampler Instrument
        try? instrument.loadInstrument(at: Bundle.main.url(forResource: "Sounds/YDP-GrandPiano-20160804", withExtension: "sf2")!)
        
        midiFile = AppleSequencer(fromURL: Bundle.main.url(forResource: "may_your_soul_rest", withExtension: "mid", subdirectory: "Examples")!)
        print("track count:", midiFile.trackCount)
        midiFile.tracks[0].setMIDIOutput(instrument.midiIn)
        
    }
    
    func start() {
        try? engine.start()
        midiFile.play()
    }
}
