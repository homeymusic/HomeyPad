import SwiftUI
import MIDIKit
import HomeyMusicKit

class ViewConductor: ObservableObject {
    
    init(
        layoutChoice: LayoutChoice,
        latching: Bool = false,
        sendTonicState: Bool = false,
        tonalContext: TonalContext
    ) {
        
        _tonalContext = StateObject(wrappedValue: tonalContext)
        
        // Set up other properties.
        self.layoutChoice        = layoutChoice
        self.latching            = latching
        
        if layoutChoice != .mode && layoutChoice != .tonic {
            synthConductor = SynthConductor()
        }
    }
    @StateObject var tonalContext: TonalContext

    @Published var synthConductor: SynthConductor?
    
    @Published var layoutChoice: LayoutChoice = .isomorphic {
        didSet(oldLayoutChoice) {
            if oldLayoutChoice != layoutChoice {
                buzz()
            }
        }
    }
    
    @Published var latching: Bool = false {
        willSet {
            tonalContext.activatedPitches.forEach {
                synthConductor?.noteOff(pitch: $0)
                $0.deactivate()
            }
        }
        didSet {
            buzz()
        }
    }
    
    var pitchRectInfos: [PitchRectInfo] = []
    var modeRectInfos: [ModeRectInfo] = []
    
    private var isTonicLocked = false
    private var isModeLocked = false
    
    var pitchLocations: [CGPoint] = [] {
        didSet {
            
            var touchedPitches = Set<Pitch>()
            
            // Process the touch locations and determine which keys are touched
            for location in pitchLocations {
                var pitch: Pitch?
                var highestZindex = -1
                
                // Find the pitch at this location with the highest Z-index
                for info in pitchRectInfos where info.rect.contains(location) {
                    if pitch == nil || info.zIndex > highestZindex {
                        pitch = info.pitch
                        highestZindex = info.zIndex
                    }
                }
                
                if let p = pitch {
                    touchedPitches.insert(p)
                    
                    if layoutChoice == .tonic {
                        // Handle tonic mode
                        if !isTonicLocked {
                            updateTonic(p)
                            isTonicLocked = true
                        }
                    } else {
                        // Handle latching
                        if latching {
                            if !latchingTouchedPitches.contains(p) {
                                latchingTouchedPitches.insert(p)
                                // Toggle pitch activation
                                if p.isActivated {
                                    synthConductor?.noteOff(pitch: p)
                                    p.deactivate()
                                } else {
                                    synthConductor?.noteOn(pitch: p)
                                    p.activate()
                                }
                            }
                        } else {
                            // Non-latching: simply activate pitch
                            if !p.isActivated {
                                synthConductor?.noteOn(pitch: p)
                                p.activate()
                            }
                        }
                    }
                }
            }
            
            // Handle un-touching in non-latching
            if !latching {
                for pitch in tonalContext.activatedPitches {
                    if !touchedPitches.contains(pitch) {
                        synthConductor?.noteOff(pitch: pitch)
                        pitch.deactivate()
                    }
                }
            }
            
            // When all touches are released, reset the tonic lock and latching set
            if pitchLocations.isEmpty {
                isTonicLocked = false
                latchingTouchedPitches.removeAll()  // Clear for the next interaction
            }
        }
    }
    
    var modeLocations: [CGPoint] = [] {
        didSet {
            
            // Process the touch locations and determine which keys are touched
            for location in modeLocations {
                var mode: Mode?
                
                // Find the pitch at this location with the highest Z-index
                for info in modeRectInfos where info.rect.contains(location) {
                    if mode == nil {
                        mode = info.mode
                    }
                }
                
                if let m = mode {
                    
                    // Handle tonic mode
                    if !isModeLocked {
                        updateMode(m)
                        isModeLocked = true
                    }
                }
            }
            
            // When all touches are released, reset the tonic lock and latching set
            if modeLocations.isEmpty {
                isModeLocked = false
            }
        }
    }
    
    // A set to track which pitches have been latched
    private var latchingTouchedPitches = Set<Pitch>()
    // Helper function to update the tonic
    private func updateTonic(_ newTonicPitch: Pitch) {
        if newTonicPitch != tonalContext.tonicPitch {
            // Adjust pitch direction if the new tonic is an octave shift
            if newTonicPitch.isOctave(relativeTo: tonalContext.tonicPitch) {
                tonalContext.pitchDirection = newTonicPitch.midiNote.number > tonalContext.tonicPitch.midiNote.number ? .downward : .upward
            }
            tonalContext.tonicPitch = newTonicPitch
        }
    }
    
    private func updateMode(_ newMode: Mode) {
        if newMode != tonalContext.mode {
            // Adjust pitch direction if the new tonic is an octave shift
            tonalContext.mode = newMode
        }
    }
    
}
