import SwiftUI
import AVFoundation
import HomeyMusicKit

@main
struct HomeyPad: App {
    
    @State private var instrumentalContext: InstrumentalContext
    @State private var tonalContext: TonalContext
    @State private var notationalContext: NotationalContext
    @State private var notationalTonicContext: NotationalTonicContext
    @State private var midiConductor: MIDIConductor
    @State private var synthConductor: SynthConductor
    
    init() {
        // Create local instances
        let __instrumentalContext = InstrumentalContext()
        let __tonalContext = TonalContext()
        let __notationalContext = NotationalContext()
        let __synthConductor = SynthConductor()
        
        // Set up callback approach for pitch activation -> noteOn/noteOff
//        for pitch in __tonalContext.allPitches {
//            // If your Pitch class has `public var onActivationChanged: ((Pitch,Bool)->Void)?`
//            pitch.onActivationChanged = { [weak __synthConductor, weak pitch] _, isActivated in
//                guard let synthConductor = __synthConductor, let pitch = pitch else { return }
//                if isActivated {
//                    print("if isActivated synth on")
//                    synthConductor.noteOn(pitch: pitch)
//                } else {
//                    print("else !isActivated synth off")
//                    synthConductor.noteOff(pitch: pitch)
//                }
//            }
//        }
//        
        
//        for pitch in __tonalContext.allPitches {
//            pitch.onActivationChanged = { [weak __synthConductor] pitch, isActivated in
//                guard let synthConductor = __synthConductor else { return }
//                if isActivated {
//                    print("if isActivated synth on")
//                    synthConductor.noteOn(pitch: pitch)
//                } else {
//                    print("else !isActivated synth off")
//                    synthConductor.noteOff(pitch: pitch)
//                }
//            }
//        }
//
        
        for pitch in __tonalContext.allPitches {
            pitch.onActivationChanged = { pitch, isActivated in
                // Temporarily capture synthConductor strongly for testing
                let synthConductor = __synthConductor
                if isActivated {
                    print("if isActivated synth on")
                    synthConductor.noteOn(pitch: pitch)
                } else {
                    print("else !isActivated synth off")
                    synthConductor.noteOff(pitch: pitch)
                }
            }
        }
        // Create a local instance of MIDIConductor
        let __midiConductor = MIDIConductor(
            tonalContext: __tonalContext,
            instrumentMIDIChannelProvider: { __instrumentalContext.instrumentChoice.rawValue },
            tonicMIDIChannel: InstrumentChoice.tonicPicker.rawValue,
            clientName: "HomeyPad",
            model: "Homey Pad iOS",
            manufacturer: "Homey Music"
        )
        
        __midiConductor.setup() // start MIDI services
        
        // Assign them to @StateObservable properties:
        self.instrumentalContext = __instrumentalContext
        self.tonalContext = __tonalContext
        self.notationalContext = __notationalContext
        self.notationalTonicContext = NotationalTonicContext()
        self.synthConductor = __synthConductor
        self.midiConductor = __midiConductor
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                tonalContext: tonalContext,
                instrumentalContext: instrumentalContext,
                notationalTonicContext: notationalTonicContext
            )
            .environment(tonalContext)
            .environment(instrumentalContext)
            .environment(notationalTonicContext)
            .environment(notationalContext)
            .environment(midiConductor)
        }
    }
    
}
