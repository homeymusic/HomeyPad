import SwiftUI
import MIDIKit
import HomeyMusicKit

class ViewConductor: ObservableObject {
    
    init(
        accidental: Accidental,
        layoutChoice: LayoutChoice,
        stringsLayoutChoice: StringsLayoutChoice = .violin,
        latching: Bool = false,
        layoutPalette: LayoutPalette = LayoutPalette(),
        layoutLabel: LayoutLabel = LayoutLabel(),
        layoutRowsCols: LayoutRowsCols = LayoutRowsCols(),
        sendTonicState: Bool = false,
        tonalContext: TonalContext
    ) {
        
        _tonalContext = StateObject(wrappedValue: tonalContext)
        
        // Set up other properties.
        self.accidental          = accidental
        self.layoutChoice        = layoutChoice
        self.stringsLayoutChoice = stringsLayoutChoice
        self.latching            = latching
        self.layoutPalette       = layoutPalette
        self.layoutLabel         = layoutLabel
        self.layoutRowsCols      = layoutRowsCols
        
        if layoutChoice != .mode && layoutChoice != .tonic {
            synthConductor = SynthConductor()
        }
    }
    @StateObject var tonalContext: TonalContext

    let animationStyle: Animation = Animation.linear
    
    var showModes: Bool {
        noteLabel[.mode]! || noteLabel[.guide]!
    }
    
    var showTonicLabels: Bool {
        noteLabel[.letter]! || noteLabel[.fixedDo]! || noteLabel[.month]! ||
        intervalLabel[.symbol]! ||
        intervalLabel[.interval]! || intervalLabel[.movableDo]! ||
        intervalLabel[.roman]! || intervalLabel[.degree]! || intervalLabel[.integer]!
    }
    
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
    
    public var nearbyNotes: [Int] {
        
        let tritoneSemitones = tonalContext.pitchDirection == .downward ? -6 : +6
        let tritoneMIDI =  Int(tonalContext.tonicMIDI) + tritoneSemitones
        
        let naturalsPerSide = layoutRowsCols.colsPerSide[self.layoutChoice]!
        
        // Make sure naturalsPerSide is positive; if not, just return tritoneMIDI.
        guard naturalsPerSide > 0 else { return [tritoneMIDI] }
        
        // Find the natural note below tritoneMIDI.
        var lowerCount = 0
        var lowerBound = tritoneMIDI
        var candidate = tritoneMIDI - 1
        while lowerCount < naturalsPerSide {
            if Pitch.isNatural(candidate) {
                lowerBound = candidate
                lowerCount += 1
            }
            candidate -= 1
        }
        
        // Find the natural note above tritoneMIDI.
        var upperCount = 0
        var upperBound = tritoneMIDI
        candidate = tritoneMIDI + 1
        while upperCount < naturalsPerSide {
            if Pitch.isNatural(candidate) {
                upperBound = candidate
                upperCount += 1
            }
            candidate += 1
        }
        
        // Return all MIDI note numbers between the two natural notes.
        return Array(lowerBound...upperBound)
    }
    
    public var layoutCols: ClosedRange<Int> {
        let tritoneSemitones = tonalContext.pitchDirection == .downward ? -6 : +6
        let lowerBound: Int = Int(tonalContext.tonicMIDI) + tritoneSemitones - layoutRowsCols.colsPerSide[self.layoutChoice]!
        let upperBound: Int = Int(tonalContext.tonicMIDI) + tritoneSemitones + layoutRowsCols.colsPerSide[self.layoutChoice]!
        return lowerBound ... upperBound
    }
    
    public var layoutRows: [Int] {        
        return (-layoutRowsCols.rowsPerSide[self.layoutChoice]!...layoutRowsCols.rowsPerSide[self.layoutChoice]!).reversed()
    }
    
    let primaryColor: CGColor = #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1)
    let secondaryColor: CGColor = #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1)
    let goldenRatio = (1 + sqrt(5)) / 2
    
    var openStringsMIDI: [Int] {
        stringsLayoutChoice.openStringsMIDI
    }
    
    @Published var showHelp: Bool = false
    
    var midiChannel: MIDIChannel {
        layoutChoice.midiChannel(stringsLayoutChoice: stringsLayoutChoice)
    }
    
    var isPaletteDefault: Bool {
        layoutPalette.choices[layoutChoice] == LayoutPalette.defaultLayoutPalette[layoutChoice] &&
        layoutPalette.outlineChoice[layoutChoice] == LayoutPalette.defaultLayoutOutline[layoutChoice]
    }
    
    func resetPaletteChoice() {
        layoutPalette.choices[layoutChoice] = LayoutPalette.defaultLayoutPalette[layoutChoice]
        layoutPalette.outlineChoice[layoutChoice] = LayoutPalette.defaultLayoutOutline[layoutChoice]
        buzz()
    }
    
    var labelsCount: Int {
        Array(noteLabels[layoutChoice]!.values).filter{$0}.count +
        Array(intervalLabels[layoutChoice]!.values).filter{$0}.count
    }
    
    var areLabelsDefault: Bool {
        noteLabels[layoutChoice] == LayoutLabel.defaultNoteLabels[layoutChoice] &&
        intervalLabels[layoutChoice] == LayoutLabel.defaultIntervalLabels[layoutChoice] &&
        self.accidental == .default
    }
    
    func resetLabels() {
        resetNoteLabels()
        resetIntervalLabels()
        resetAccidental()
        buzz()
    }
    
    func resetNoteLabels() {
        layoutLabel.noteLabelChoices[layoutChoice] = LayoutLabel.defaultNoteLabels[layoutChoice]
    }
    
    func resetIntervalLabels() {
        layoutLabel.intervalLabelChoices[layoutChoice] = LayoutLabel.defaultIntervalLabels[layoutChoice]
    }
    
    func resetAccidental() {
        self.accidental = .default
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
    
    func fewerRows() {
        layoutRowsCols.rowsPerSide[layoutChoice]! -= 1
    }
    
    func moreRows() {
        layoutRowsCols.rowsPerSide[layoutChoice]! += 1
    }
    
    func fewerCols() {
        switch layoutChoice {
        case .symmetric:
            let colJump: [Int:Int] = [
                29:2,
                27:2,
                25:3,
                22:2,
                20:2,
                17:2,
                15:2,
                13:3,
                10:2,
                8:2
            ]
            layoutRowsCols.colsPerSide[layoutChoice]! -= colJump[layoutRowsCols.colsPerSide[layoutChoice]!] ?? 1
        default: layoutRowsCols.colsPerSide[layoutChoice]! -= 1
        }
    }
    
    func moreCols() {
        switch layoutChoice {
        case .symmetric:
            let colJump: [Int:Int] = [
                6:2,
                8:2,
                10:3,
                13:2,
                15:2,
                18:2,
                20:2,
                22:3,
                25:2,
                27:2
            ]
            layoutRowsCols.colsPerSide[layoutChoice]! += colJump[layoutRowsCols.colsPerSide[layoutChoice]!] ?? 1
        default: layoutRowsCols.colsPerSide[layoutChoice]! += 1
        }
    }
    
    var showRowColsReset: Bool {
        layoutRowsCols.colsPerSide[layoutChoice] != LayoutRowsCols.defaultColsPerSide[layoutChoice] ||
        layoutRowsCols.rowsPerSide[layoutChoice] != LayoutRowsCols.defaultRowsPerSide[layoutChoice]
    }
    
    var showMoreRows: Bool {
        layoutRowsCols.rowsPerSide[layoutChoice]! < LayoutRowsCols.maxRowsPerSide[layoutChoice]!
    }
    
    var showFewerRows: Bool {
        layoutRowsCols.rowsPerSide[layoutChoice]! > LayoutRowsCols.minRowsPerSide[layoutChoice]!
    }
    
    var showFewerColumns: Bool {
        layoutRowsCols.colsPerSide[layoutChoice]! > LayoutRowsCols.minColsPerSide[layoutChoice]!
    }
    
    var showMoreColumns: Bool {
        layoutRowsCols.colsPerSide[layoutChoice]! < LayoutRowsCols.maxColsPerSide[layoutChoice]!
    }
    
    func resetRowsColsPerSide() {
        resetRowsPerSide()
        resetColsPerSide()
    }
    
    @Published var layoutRowsCols: LayoutRowsCols = LayoutRowsCols() {
        didSet {
            buzz()
        }
    }
    
    func resetColsPerSide() {
        layoutRowsCols.colsPerSide[layoutChoice]! = LayoutRowsCols.defaultColsPerSide[layoutChoice]!
    }
    
    func resetRowsPerSide() {
        layoutRowsCols.rowsPerSide[layoutChoice]! = LayoutRowsCols.defaultRowsPerSide[layoutChoice]!
    }
    
    var pitchRectInfos: [PitchRectInfo] = []
    var modeRectInfos: [ModeRectInfo] = []
    
    var isOneRowOnTablet : Bool {
        HomeyPad.formFactor == .iPad && layoutRowsCols.rowsPerSide[layoutChoice]! == 0
    }
    
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
    
    @Published var accidental: Accidental = .default {
        didSet {
            buzz()
        }
    }
    
    func tritoneLength(proxySize: CGSize) -> CGFloat {
        return min(proxySize.height * 1/3, proxySize.width)
    }
    
}

