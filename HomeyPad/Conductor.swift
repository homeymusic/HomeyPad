import AVFoundation

class Conductor {
    private let engine = AVAudioEngine()
    private var oscillators: [Oscillator] = []
    private let maxPolyphony = 8  // Maximum number of notes that can be played simultaneously

    // Initialize and attach custom oscillators
    init() {
        for _ in 0..<maxPolyphony {
            let oscillator = Oscillator()
            oscillators.append(oscillator)
        }

        let mixer = engine.mainMixerNode
        for oscillator in oscillators {
            engine.attach(oscillator.node)
            engine.connect(oscillator.node, to: mixer, format: nil)
        }
    }

    // Start the audio engine
    public func start() {
        do {
            try engine.start()
        } catch {
            print("Error starting the audio engine: \(error.localizedDescription)")
        }
    }

    // Play a note (noteOn) using the Pitch's frequency value
    public func noteOn(pitch: Pitch) {
        let frequency = pitch.frequency  // Using pitch.frequency directly
        if let availableOscillator = oscillators.first(where: { !$0.isPlaying }) {
            availableOscillator.play(frequency: Double(frequency))
        }
    }

    // Stop a note (noteOff) using the Pitch's frequency value
    public func noteOff(pitch: Pitch) {
        let frequency = pitch.frequency  // Using pitch.frequency directly
        if let playingOscillator = oscillators.first(where: { $0.isPlaying && $0.frequency == Double(frequency) }) {
            playingOscillator.stop()
        }
    }
}

class Oscillator {
    private(set) var frequency: Double = 440.0
    private(set) var isPlaying: Bool = false
    private var currentPhase: Float = 0
    private let sampleRate: Float = 44100.0
    
    // Declare the node as lazy so it captures self after initialization
    lazy var node: AVAudioSourceNode = {
        AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self else { return noErr }
            
            let bufferPointer = audioBufferList.pointee.mBuffers.mData?.assumingMemoryBound(to: Float.self)
            guard let outputBuffer = bufferPointer else { return noErr }

            if !self.isPlaying {
                // Fill the buffer with silence if not playing
                for frame in 0..<Int(frameCount) {
                    outputBuffer[frame] = 0.0
                }
            } else {
                // Generate a sine wave signal if playing
                let phaseIncrement = Float(self.frequency * 2 * .pi / Double(self.sampleRate))
                for frame in 0..<Int(frameCount) {
                    outputBuffer[frame] = sin(self.currentPhase)
                    self.currentPhase += phaseIncrement
                    if self.currentPhase >= 2 * .pi {
                        self.currentPhase -= 2 * .pi
                    }
                }
            }
            return noErr
        }
    }()

    // Start playing the note with the given frequency
    public func play(frequency: Double) {
        self.frequency = frequency
        isPlaying = true
    }
    
    // Stop playing the note
    public func stop() {
        isPlaying = false
    }
}
