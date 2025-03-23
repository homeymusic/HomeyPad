import SwiftUI
import AVFoundation
import HomeyMusicKit
import Combine

@main
struct HomeyPad: App {
    
    @StateObject private var instrumentalContext: InstrumentalContext
    @StateObject private var tonalContext: TonalContext
    @StateObject private var notationalContext: NotationalContext
    @StateObject private var notationalTonicContext: NotationalTonicContext
    @StateObject private var midiConductor: MIDIConductor
    @StateObject private var synthConductor: SynthConductor
    
    // Store Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Initialize appContext and tonalContext as local variables.
        let instrumentalContext = InstrumentalContext()
        let tonalContext = TonalContext()
        let notationalContext = NotationalContext()
        let notationalTonicContext = NotationalTonicContext()
        let synthCondutor = SynthConductor()
        
        // Now assign them to the state objects using the underscore syntax.
        _instrumentalContext = StateObject(wrappedValue: instrumentalContext)
        _tonalContext = StateObject(wrappedValue: tonalContext)
        _notationalContext = StateObject(wrappedValue: notationalContext)
        _notationalTonicContext = StateObject(wrappedValue: notationalTonicContext)
        
        // Subscribe to each pitch’s activation publisher.
        for pitch in tonalContext.allPitches {
            pitch.$isActivated
                .removeDuplicates()
                .sink { isActivated in
                    if isActivated {
                        synthCondutor.noteOn(pitch: pitch)
                    } else {
                        synthCondutor.noteOff(pitch: pitch)
                    }
                }
                .store(in: &cancellables)
        }
        
        // Create a local instance of MIDIConductor.
        let midiConductorInstance = MIDIConductor(
            tonalContext: tonalContext,
            instrumentMIDIChannelProvider: { instrumentalContext.instrumentChoice.rawValue },
            tonicMIDIChannel: InstrumentChoice.tonicPicker.rawValue,
            clientName: "HomeyPad",
            model: "Homey Pad iOS",
            manufacturer: "Homey Music"
        )
        
        // Assign it to the state object.
        _midiConductor = StateObject(wrappedValue: midiConductorInstance)
        
        // Now call the statusRequest on the instance.
        midiConductorInstance.statusRequest()
        
        _synthConductor = StateObject(wrappedValue: synthCondutor)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                tonalContext: tonalContext,
                instrumentalContext: instrumentalContext,
                notationalTonicContext: notationalTonicContext
            )
            .environmentObject(instrumentalContext)
            .environmentObject(tonalContext)
            .environmentObject(notationalContext)
            .environmentObject(notationalTonicContext)
            .environmentObject(midiConductor)
        }
    }
    
}
