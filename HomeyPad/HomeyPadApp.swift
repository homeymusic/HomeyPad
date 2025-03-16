import SwiftUI
import AVFoundation
import HomeyMusicKit

@main
struct HomeyPad: App {
    
    @StateObject private var instrumentalContext: InstrumentalContext
    @StateObject private var tonalContext: TonalContext
    @StateObject private var notationalContext: NotationalContext
    @StateObject private var notationalTonicContext: NotationalTonicContext
    @StateObject private var midiConductor: MIDIConductor
    @StateObject private var synthConductor: SynthConductor
    
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
        
                

        
        tonalContext.addDidSetTonicPitchCallbacks { oldTonicPitch, newTonicPitch in
            if oldTonicPitch != newTonicPitch {
                if newTonicPitch.isOctave(relativeTo: oldTonicPitch) {
                    if newTonicPitch.midiNote.number > oldTonicPitch.midiNote.number {
                        tonalContext._pitchDirection = .downward
                    } else {
                        tonalContext._pitchDirection = .upward
                    }
                } else if oldTonicPitch.pitchClass != newTonicPitch.pitchClass {
                    if (notationalTonicContext.showModes) {
                        tonalContext.mode = Mode(
                            rawValue: modulo(
                                tonalContext.mode.rawValue + Int(newTonicPitch.distance(from: oldTonicPitch)), 12
                            ))!
                    }
                }
                
                buzz()
            }
        }
        
        tonalContext.addDidSetModeCallbacks { oldMode, newMode in
            if oldMode != newMode {
                if notationalTonicContext.showModes && newMode.pitchDirection != .mixed {
                    tonalContext._pitchDirection = newMode.pitchDirection
                }
                buzz()
            }
        }
        
        tonalContext.addDidSetPitchDirectionCallbacks { oldPitchDirection, newPitchDirection in
            if oldPitchDirection != newPitchDirection {
                switch (oldPitchDirection, newPitchDirection) {
                    case (.upward, .downward):
                    tonalContext.shiftUpOneOctave()
                    case (.downward, .upward):
                    tonalContext.shiftDownOneOctave()
                    default:
                        break
                    }
                buzz()
            }
        }
        
        for pitch in tonalContext.allPitches {
            pitch.addOnActivateCallback { activatedPitch in
                synthCondutor.noteOn(pitch: activatedPitch)
            }
            pitch.addOnDeactivateCallback { deactivatedPitch in
                synthCondutor.noteOff(pitch: deactivatedPitch)
            }
        }
        
        // Now it's safe to use them to initialize midiConductor.
        _midiConductor = StateObject(wrappedValue: MIDIConductor(
            tonalContext: tonalContext,
            instrumentMIDIChannelProvider: { instrumentalContext.instrumentChoice.rawValue },
            tonicMIDIChannel: InstrumentChoice.tonicPicker.rawValue,
            clientName: "HomeyPad",
            model: "Homey Pad iOS",
            manufacturer: "Homey Music"
        ))
        
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
