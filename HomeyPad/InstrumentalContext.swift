import SwiftUI
import HomeyMusicKit

final class InstrumentalContext: ObservableObject {
    @Published var instrumentType: InstrumentType {
        didSet {
            if instrumentType.isStringInstrument {
                stringInstrumentType = instrumentType
            }
        }
    }
    @Published var stringInstrumentType: InstrumentType
    
    @Published var latching: Bool
    
    private(set) var instrumentByType: [InstrumentType: Instrument] = {
        var mapping: [InstrumentType: Instrument] = [:]
        InstrumentType.allCases.forEach { instrumentType in
            switch instrumentType {
            case .isomorphic:
                mapping[instrumentType] = Isomorphic()
            case .tonnetz:
                mapping[instrumentType] = Tonnetz()
            case .diamanti:
                mapping[instrumentType] = Diamanti()
            case .piano:
                mapping[instrumentType] = Piano()
            case .violin:
                mapping[instrumentType] = Violin()
            case .cello:
                mapping[instrumentType] = Cello()
            case .bass:
                mapping[instrumentType] = Bass()
            case .banjo:
                mapping[instrumentType] = Banjo()
            case .guitar:
                mapping[instrumentType] = Guitar()
            case .tonicPicker:
                mapping[instrumentType] = TonicPicker()
            }
        }
        return mapping
    }()
    
    /// Returns the current instrument instance based on instrumentType.
    public var instrument: Instrument {
        guard let inst = instrumentByType[instrumentType] else {
            fatalError("No instrument instance found for \(instrumentType)")
        }
        return inst
    }
    
    /// Returns the current keyboard instrument.
    public var keyboardInstrument: KeyboardInstrument {
        guard let inst = instrumentByType[instrumentType] as? KeyboardInstrument else {
            fatalError("No keyboard instrument instance found for \(instrumentType)")
        }
        return inst
    }
    
    init() {
        self.instrumentType = .diamanti
        self.stringInstrumentType = .violin
        self.latching = false
    }
    
    public var instruments: [InstrumentType] {
        InstrumentType.keyboardInstruments + [self.stringInstrumentType]
    }
    
    var pitchRectInfos: [PitchRectInfo] = []
    private var latchingTouchedPitches = Set<Pitch>()
    @Published var synthConductor: SynthConductor = SynthConductor()
    
    public func setPitchLocations(
        pitchLocations: [CGPoint],
        tonalContext: TonalContext
    ) {
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
                
                if latching {
                    if !latchingTouchedPitches.contains(p) {
                        latchingTouchedPitches.insert(p)
                        // Toggle pitch activation
                        if p.isActivated {
                            synthConductor.noteOff(pitch: p)
                            p.deactivate()
                        } else {
                            synthConductor.noteOn(pitch: p)
                            p.activate()
                        }
                    }
                } else {
                    if !p.isActivated {
                        synthConductor.noteOn(pitch: p)
                        p.activate()
                    }
                }
            }
        }
        
        if !latching {
            for pitch in tonalContext.activatedPitches {
                if !touchedPitches.contains(pitch) {
                    synthConductor.noteOff(pitch: pitch)
                    pitch.deactivate()
                }
            }
        }
        
        if pitchLocations.isEmpty {
            latchingTouchedPitches.removeAll()  // Clear for the next interaction
        }
    }
        
    var tonicRectInfos: [TonicRectInfo] = []
    private var isTonicLocked = false
    
    public func setTonicLocations(tonicLocations: [CGPoint], tonalContext: TonalContext) {
        print("tonicLocations", tonicLocations)
        for location in tonicLocations {
            var tonicPitch: Pitch?
            
            for info in tonicRectInfos where info.rect.contains(location) {
                if tonicPitch == nil {
                    tonicPitch = info.pitch
                }
            }
            
            if let t = tonicPitch {
                if !isTonicLocked {
                    updateTonic(t, tonalContext: tonalContext)
                    isTonicLocked = true
                }
            }
        }
        
        if tonicLocations.isEmpty {
            isTonicLocked = false
        }
    }
    
    
    private func updateTonic(_ newTonicPitch: Pitch, tonalContext: TonalContext) {
        print("updateTonic")
        if newTonicPitch != tonalContext.tonicPitch {
            // Adjust pitch direction if the new tonic is an octave shift
            if newTonicPitch.isOctave(relativeTo: tonalContext.tonicPitch) {
                tonalContext.pitchDirection = newTonicPitch.midiNote.number > tonalContext.tonicPitch.midiNote.number ? .downward : .upward
            }
            tonalContext.tonicPitch = newTonicPitch
        }
    }
    
    var modeRectInfos: [ModeRectInfo] = []
    private var isModeLocked = false
    
    public func setModeLocations(modeLocations: [CGPoint], tonalContext: TonalContext) {
        print("modeLocations", modeLocations)
        for location in modeLocations {
            var mode: Mode?
            
            // Find the pitch at this location with the highest Z-index
            for info in modeRectInfos where info.rect.contains(location) {
                if mode == nil {
                    mode = info.mode
                }
            }
            
            if let m = mode {
                if !isModeLocked {
                    updateMode(m, tonalContext: tonalContext)
                    isModeLocked = true
                }
            }
        }
        
        if modeLocations.isEmpty {
            isModeLocked = false
        }
    }
    
    private func updateMode(_ newMode: Mode, tonalContext: TonalContext) {
        print("updateMode")
        if newMode != tonalContext.mode {
            // Adjust pitch direction if the new tonic is an octave shift
            tonalContext.mode = newMode
        }
    }
    
    
}
