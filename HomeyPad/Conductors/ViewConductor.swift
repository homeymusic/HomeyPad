import SwiftUI
import MIDIKit
import HomeyMusicKit

class ViewConductor: ObservableObject {
    
    init(tonicMIDI: Int, pitchDirection: PitchDirection, accidental: Accidental, layoutChoice: LayoutChoice, stringsLayoutChoice: StringsLayoutChoice = StringsLayoutChoice.violin, latching: Bool = false, layoutPalette: LayoutPalette = LayoutPalette(), layoutLabel: LayoutLabel = LayoutLabel(), layoutRowsCols: LayoutRowsCols = LayoutRowsCols(), sendTonicState: Bool = false) {
        // defaults
        self.tonicMIDI           = tonicMIDI
        self.pitchDirection      = pitchDirection
        self.accidental          = accidental
        self.layoutChoice        = layoutChoice
        self.stringsLayoutChoice = stringsLayoutChoice
        self.latching            = latching
        self.layoutPalette       = layoutPalette
        self.layoutLabel         = layoutLabel
        self.layoutRowsCols      = layoutRowsCols
        self.sendTonicState      = sendTonicState
        
        // setup
        self.backgroundColor = (layoutChoice == .tonic) ? Color(UIColor.systemGray6) : .black
        self.allPitches = Array(0...127).map {Pitch($0)}
        self.allPitches[tonicMIDI].isTonic = true
        // Pass the `sendCurrentState` function into the MIDIHelper during creation
        midiHelper = MIDIConductor(sendCurrentState: self.sendCurrentState)
        midiHelper?.setup(midiManager: midiManager)
    }
    
    
    let sendTonicState: Bool
    var midiHelper: MIDIConductor?

    func sendCurrentState() {
        if sendTonicState {
            midiHelper?.sendTonic(noteNumber: UInt7(tonicMIDI), midiChannel: midiChannel(layoutChoice: self.layoutChoice, stringsLayoutChoice: self.stringsLayoutChoice))
            midiHelper?.sendPitchDirection(upwardPitchDirection: self.pitchDirection == .upward, midiChannel: midiChannel(layoutChoice: self.layoutChoice, stringsLayoutChoice: self.stringsLayoutChoice))
        } else {
            activePitchesNoteOn(activePitches: externallyActivatedPitches)
        }
        print("ViewConductor's current state sent.")
    }
    
    let conductor = SynthConductor()
    
    let backgroundColor: Color
    
    let animationStyle: Animation = Animation.linear
    
    let allPitches: [Pitch]
    
    let midiManager = ObservableMIDIManager(
        clientName: "Homey Pad",
        model: "iOS",
        manufacturer: "Homey Music"
    )
    
    func midiChannel(layoutChoice: LayoutChoice, stringsLayoutChoice: StringsLayoutChoice) -> UInt4 {
        layoutChoice.midiChannel(stringsLayoutChoice: stringsLayoutChoice)
    }
    
    @Published var layoutChoice: LayoutChoice = .isomorphic {
        didSet(oldLayoutChoice) {
            if oldLayoutChoice != layoutChoice {
                Task { @MainActor in
                    buzz()
                }
                let activePitches = externallyActivatedPitches
                allPitchesNoteOff(layoutChoice: oldLayoutChoice, stringsLayoutChoice: self.stringsLayoutChoice)
                if self.latching {
                    activePitchesNoteOn(activePitches: activePitches)
                }
            }
        }
    }
    
    @Published var stringsLayoutChoice: StringsLayoutChoice = .violin {
        didSet(oldStringsLayoutChoice) {
            if oldStringsLayoutChoice != stringsLayoutChoice {
                Task { @MainActor in
                    buzz()
                }
                let activePitches = externallyActivatedPitches
                allPitchesNoteOff(layoutChoice: .strings, stringsLayoutChoice: oldStringsLayoutChoice)
                if self.latching {
                    activePitchesNoteOn(activePitches: activePitches)
                }
            }
        }
    }
    
    @Published var latching: Bool = false {
        willSet {
            externallyActivatedPitches.removeAll()
        }
        didSet {
            Task { @MainActor in
                buzz()
            }
        }
    }
    
    var tonicPitch: Pitch {
        allPitches[tonicMIDI]
    }
    
    var octaveShift: Int8 {
        get {
            let midi = if pitchDirection == .upward || !safeMIDI(midi: tonicMIDI - 12) {
                tonicMIDI
            } else {
                tonicMIDI - 12
            }
            return Int8(allPitches[midi].octave - 4)
        }
        set(newOctaveShift) {
            tonicMIDI = tonicMIDI + 12 * (Int(newOctaveShift) + 5)
        }
    }

    var octaveMIDI: Int {
        tonicMIDI + (pitchDirection == .upward || pitchDirection == .both ? 12 : -12)
    }
    
    var tritoneMIDI: Int {
        tonicMIDI + (pitchDirection == .upward || pitchDirection == .both ? 6 : -6)
    }
    
    var tritonePitch: Pitch {
        allPitches[tritoneMIDI]
    }
    
    var lowMIDI: Int {
        Int(tritoneMIDI) - layoutRowsCols.colsPerSide[self.layoutChoice]!
    }
    
    var highMIDI: Int {
        Int(tritoneMIDI) + layoutRowsCols.colsPerSide[self.layoutChoice]!
    }
    
    let brownColor: CGColor = #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1)
    let creamColor: CGColor = #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1)
    
    var mainColor: Color {
        return Color(brownColor)
    }
    
    var openStringsMIDI: [Int] {
        stringsLayoutChoice.openStringsMIDI
    }
    
    @Published var showHelp: Bool = false
    
    func allPitchesNoteOff(layoutChoice: LayoutChoice, stringsLayoutChoice: StringsLayoutChoice) {
        let midiChannel = midiChannel(layoutChoice: layoutChoice, stringsLayoutChoice: stringsLayoutChoice)
        self.allPitches.forEach {pitch in
            deactivatePitch(pitch: pitch, midiChannel: midiChannel)
        }
    }
    
    func activePitchesNoteOn(activePitches: Set<Pitch>) {
        let midiChannel = midiChannel(layoutChoice: self.layoutChoice, stringsLayoutChoice: self.stringsLayoutChoice)
        activePitches.forEach {pitch in
            activatePitch(pitch: pitch, midiChannel: midiChannel)
        }
    }

    var isPaletteDefault: Bool {
        layoutPalette.choices[layoutChoice] == LayoutPalette.defaultLayoutPalette[layoutChoice] &&
        layoutPalette.outlineChoice[layoutChoice] == LayoutPalette.defaultLayoutOutline[layoutChoice]
    }
    
    func resetPaletteChoice() {
        layoutPalette.choices[layoutChoice] = LayoutPalette.defaultLayoutPalette[layoutChoice]
        layoutPalette.outlineChoice[layoutChoice] = LayoutPalette.defaultLayoutOutline[layoutChoice]
        Task { @MainActor in
            buzz()
        }
    }
    
    var isTonicDefault: Bool {
        tonicMIDI == 60 && pitchDirection == .upward
    }

    func resetTonic() {
        pitchDirection = .upward
        tonicMIDI = 60
        Task { @MainActor in
            buzz()
        }
    }

    var labelsCount: Int {
        Array(noteLabels[layoutChoice]!.values).filter{$0}.count +
        Array(intervalLabels[layoutChoice]!.values).filter{$0}.count
    }
    
    var areLabelsDefault: Bool {
        noteLabels[layoutChoice] == LayoutLabel.defaultNoteLabels[layoutChoice] &&
        intervalLabels[layoutChoice] == LayoutLabel.defaultIntervalLabels[layoutChoice] &&
        accidental == Accidental.defaultAccidental
    }
    
    func resetLabels() {
        resetNoteLabels()
        resetIntervalLabels()
        resetAccidental()
        Task { @MainActor in
            buzz()
        }
    }
    
    func resetNoteLabels() {
        layoutLabel.noteLabelChoices[layoutChoice] = LayoutLabel.defaultNoteLabels[layoutChoice]
    }
    
    func resetIntervalLabels() {
        layoutLabel.intervalLabelChoices[layoutChoice] = LayoutLabel.defaultIntervalLabels[layoutChoice]
    }
    
    func resetAccidental() {
        accidental = Accidental.defaultAccidental
    }
    
    var paletteChoice: PaletteChoice {
        layoutPalette.choices[layoutChoice]!
    }
    
    var outlineChoice: Bool {
        layoutPalette.outlineChoice[layoutChoice]!
    }

    @Published var layoutPalette: LayoutPalette = LayoutPalette() {
        willSet(newLayoutPalette) {
            Task { @MainActor in
                buzz()
            }
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
            Task { @MainActor in
                buzz()
            }
        }
    }
    
    func resetColsPerSide() {
        layoutRowsCols.colsPerSide[layoutChoice]! = LayoutRowsCols.defaultColsPerSide[layoutChoice]!
    }
    
    
    func resetRowsPerSide() {
        layoutRowsCols.rowsPerSide[layoutChoice]! = LayoutRowsCols.defaultRowsPerSide[layoutChoice]!
    }
    
    var keyRectInfos: [KeyRectInfo] = []
    var normalizedPoints = Array(repeating: CGPoint.zero, count: 128)

    var isOneRowOnTablet : Bool {
        HomeyPad.formFactor == .iPad && layoutRowsCols.rowsPerSide[layoutChoice]! == 0
    }
    
    var touchLocations: [CGPoint] = [] {
        didSet {
            var newPitches = Set<Pitch>()
            for location in touchLocations {
                var pitch: Pitch?
                var highestZindex = -1
                var normalizedPoint = CGPoint.zero
                for info in keyRectInfos where info.rect.contains(location) {
                    if pitch == nil || info.zIndex > highestZindex {
                        pitch = info.pitch
                        highestZindex = info.zIndex
                        normalizedPoint = CGPoint(x: (location.x - info.rect.minX) / info.rect.width,
                                                  y: (location.y - info.rect.minY) / info.rect.height)
                    }
                }
                if let p = pitch {
                    newPitches.insert(p)
                    normalizedPoints[p.intValue] = normalizedPoint
                }
            }
            if touchedPitches != newPitches {
                touchedPitches = newPitches
            }
        }
    }
    
    /// all touched notes
    @Published public var touchedPitches = Set<Pitch>() {
        willSet {
            triggerEvents(from: touchedPitches, to: newValue)
        }
    }
    
    /// Either latched keys or keys active due to external MIDI events.
    @Published public var externallyActivatedPitches = Set<Pitch>() {
        willSet {
            triggerEvents(from: externallyActivatedPitches, to: newValue)
        }
    }
    
    @Published var tonicMIDI: Int {
        willSet(newTonicMIDI) {
            allPitches[tonicMIDI].isTonic = false
            if safeMIDI(midi: newTonicMIDI) {
                allPitches[newTonicMIDI].isTonic = true
            } else {
                if newTonicMIDI < 0 {
                    allPitches[0].isTonic = true
                } else if newTonicMIDI > 127 {
                    allPitches[127].isTonic = true
                }
            }
        }
        didSet {
            if layoutChoice == .tonic {
                midiHelper?.sendTonic(noteNumber: UInt7(tonicMIDI), midiChannel: midiChannel(layoutChoice: layoutChoice, stringsLayoutChoice: stringsLayoutChoice))
            }
        }
    }
    
    @Published var pitchDirection: PitchDirection = .upward {
        didSet {
            if layoutChoice == .tonic {
                if pitchDirection == .upward {
                    if safeMIDI(midi: tonicMIDI - 12) {
                        tonicMIDI = tonicMIDI - 12
                    }
                } else if pitchDirection == .downward {
                    if safeMIDI(midi: tonicMIDI + 12) {
                        tonicMIDI = tonicMIDI + 12
                    }
                }
                midiHelper?.sendPitchDirection(upwardPitchDirection: pitchDirection == .upward, midiChannel: midiChannel(layoutChoice: layoutChoice, stringsLayoutChoice: stringsLayoutChoice))
                Task { @MainActor in
                    buzz()
                }
            }
        }
    }
    
    @Published var accidental: Accidental = Accidental.defaultAccidental {
        didSet {
            Task { @MainActor in
                buzz()
            }
        }
    }

    func triggerEvents(from oldValue: Set<Pitch>, to newValue: Set<Pitch>) {
        let newPitches = newValue.subtracting(oldValue)
        let oldPitches = oldValue.subtracting(newValue)
        if layoutChoice == .tonic {
            for pitch in newPitches {
                let newTonicMIDI = Int(pitch.midi)
                if newTonicMIDI != tonicMIDI {
                    if newTonicMIDI == tonicMIDI + 12 {
                        pitchDirection = .downward
                    } else if newTonicMIDI == tonicMIDI - 12 {
                        pitchDirection = .upward
                    }
                    tonicMIDI = newTonicMIDI
                    Task { @MainActor in
                        buzz()
                    }
                }
            }
        } else {
            for pitch in newPitches {
                activatePitch(pitch: pitch,
                              midiChannel: midiChannel(layoutChoice: self.layoutChoice, stringsLayoutChoice: self.stringsLayoutChoice))
            }
            for pitch in oldPitches {
                deactivatePitch(pitch: pitch,
                                midiChannel: midiChannel(layoutChoice: self.layoutChoice, stringsLayoutChoice: self.stringsLayoutChoice))
            }
        }
    }
    
    func activatePitch(pitch: Pitch, midiChannel: UInt4) {
        midiHelper?.sendNoteOn(noteNumber: UInt7(pitch.midi), midiChannel: midiChannel)
        pitch.noteOn()
        conductor.noteOn(pitch: pitch)
    }
    
    func deactivatePitch(pitch: Pitch, midiChannel: UInt4) {
        midiHelper?.sendNoteOff(noteNumber: UInt7(pitch.intValue), midiChannel: midiChannel)
        pitch.noteOff()
        conductor.noteOff(pitch: pitch)
    }

    static var currentTritoneLength: CGFloat = 0.0
    
    func tritoneLength(proxySize: CGSize) -> CGFloat {
        ViewConductor.currentTritoneLength = min(proxySize.height * 1/3, proxySize.width)
        return ViewConductor.currentTritoneLength
    }
    
    func reloadAudio() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !self.conductor.engine.avEngine.isRunning {
                self.conductor.start()
            }
        }
    }
}

