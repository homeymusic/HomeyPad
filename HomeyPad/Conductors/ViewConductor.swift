import SwiftUI
import MIDIKit
import HomeyMusicKit

class ViewConductor: ObservableObject {
    
    init(
        layoutChoice: LayoutChoice,
        stringsLayoutChoice: StringsLayoutChoice = .violin,
        latching: Bool = false,
        layoutPalette: LayoutPalette = LayoutPalette(),
        layoutLabel: LayoutLabel = LayoutLabel(),
        sendTonicState: Bool = false,
        tonalContext: TonalContext
    ) {
        
        _tonalContext = StateObject(wrappedValue: tonalContext)
        
        // Set up other properties.
        self.layoutChoice        = layoutChoice
        self.stringsLayoutChoice = stringsLayoutChoice
        self.latching            = latching
        self.layoutPalette       = layoutPalette
        self.layoutLabel         = layoutLabel
        
        if layoutChoice != .mode && layoutChoice != .tonic {
            synthConductor = SynthConductor()
        }
    }
    @StateObject var tonalContext: TonalContext

    let animationStyle: Animation = Animation.linear
    
    @Published var synthConductor: SynthConductor?
    
    @Published var layoutChoice: LayoutChoice = .isomorphic {
        didSet(oldLayoutChoice) {
            if oldLayoutChoice != layoutChoice {
                buzz()
            }
        }
    }
    
    @Published var stringsLayoutChoice: StringsLayoutChoice = .violin {
        didSet(oldStringsLayoutChoice) {
            if oldStringsLayoutChoice != stringsLayoutChoice {
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
    
    @Published var showHelp: Bool = false
    
    var isPaletteDefault: Bool {
        layoutPalette.choices[layoutChoice] == LayoutPalette.defaultLayoutPalette[layoutChoice] &&
        layoutPalette.outlineChoice[layoutChoice] == LayoutPalette.defaultLayoutOutline[layoutChoice]
    }
    
    func resetPaletteChoice() {
        layoutPalette.choices[layoutChoice] = LayoutPalette.defaultLayoutPalette[layoutChoice]
        layoutPalette.outlineChoice[layoutChoice] = LayoutPalette.defaultLayoutOutline[layoutChoice]
        buzz()
    }
    
    var areLabelsDefault: Bool {
        noteLabels[layoutChoice] == LayoutLabel.defaultNoteLabels[layoutChoice] &&
        intervalLabels[layoutChoice] == LayoutLabel.defaultIntervalLabels[layoutChoice]
    }
    
    func resetLabels() {
        resetNoteLabels()
        resetIntervalLabels()
        buzz()
    }
    
    func resetNoteLabels() {
        layoutLabel.noteLabelChoices[layoutChoice] = LayoutLabel.defaultNoteLabels[layoutChoice]
    }
    
    func resetIntervalLabels() {
        layoutLabel.intervalLabelChoices[layoutChoice] = LayoutLabel.defaultIntervalLabels[layoutChoice]
    }
        
    var paletteChoice: PaletteChoice {
        layoutPalette.choices[layoutChoice]!
    }
    
    var outlineChoice: Bool {
        layoutPalette.outlineChoice[layoutChoice]!
    }
    
    @Published var layoutPalette: LayoutPalette = LayoutPalette() {
        willSet(newLayoutPalette) {
            buzz()
        }
    }
    
    @Published var layoutLabel: LayoutLabel = LayoutLabel()
    
    // TODO: move all the UI choices pinned to layout choice elsewhere.
    // maybe into the Instrument instance?
    // but we are then mixing notational context with instrument context?
    // or in this case putting info stickies on the instrument is the instrument?
    
    var noteLabels: [LayoutChoice: [NoteLabelChoice: Bool]] {
        layoutLabel.noteLabelChoices
    }
    
    var noteLabel: [NoteLabelChoice: Bool] {
        noteLabels[layoutChoice]!
    }
    
    var intervalLabels: [LayoutChoice: [IntervalLabelChoice: Bool]] {
        layoutLabel.intervalLabelChoices
    }
    
    var intervalLabel: [IntervalLabelChoice: Bool] {
        intervalLabels[layoutChoice]!
    }
    
    public func noteLabelBinding(for key: NoteLabelChoice) -> Binding<Bool> {
        return Binding(
            get: {
                return self.noteLabels[self.layoutChoice]![key] ?? false
            },
            set: {
                self.layoutLabel.noteLabelChoices[self.layoutChoice]![key] = $0
            }
        )
    }
    
    public func intervalLabelBinding(for key: IntervalLabelChoice) -> Binding<Bool> {
        return Binding(
            get: {
                return self.intervalLabels[self.layoutChoice]![key] ?? false
            },
            set: {
                self.layoutLabel.intervalLabelChoices[self.layoutChoice]![key] = $0
            }
        )
    }
    
    public func outlineBinding() -> Binding<Bool> {
        return Binding(
            get: {
                return self.layoutPalette.outlineChoice[self.layoutChoice]!
            },
            set: {
                self.layoutPalette.outlineChoice[self.layoutChoice]! = $0
            }
        )
    }
    
    var showSymbols: Bool {
        intervalLabels[layoutChoice]![.symbol]!
    }
    
    func enableAccidentalPicker() -> Bool {
        return noteLabels[layoutChoice]![.letter]! ||
        noteLabels[layoutChoice]![.fixedDo]!
    }
    
    func enableOctavePicker() -> Bool {
        return noteLabels[layoutChoice]![.letter]! ||
        noteLabels[layoutChoice]![.fixedDo]! ||
        noteLabels[layoutChoice]![.month]!
    }
    
    @Published var showKeyLabelsPopover: Bool = false
    
    @Published var showPalettePopover: Bool = false
    
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
