import SwiftUI

class ViewConductor: ObservableObject {
    
    init(layoutChoice: LayoutChoice = .isomorphic, latching: Bool = false, tonicMIDI: Int = 60) {
        self.layoutChoice = layoutChoice
        self.latching = latching
        self.backgroundColor = (layoutChoice == .tonic) ? Color(UIColor.systemGray5) : .black
        self.tonicMIDI = tonicMIDI
        self.allPitches = Array(0...127).map {Pitch($0)}
        self.allPitches[tonicMIDI].isTonic = true
    }
    
    let backgroundColor: Color
    
    let animationStyle: Animation = Animation.linear
    
    let allPitches: [Pitch]
    
    
    @Published var semitoneShift: IntegerNotation = .zero
    
    @Published var layoutChoice: LayoutChoice = .isomorphic {
        willSet(newLayoutChoice) {
            if newLayoutChoice != layoutChoice {
                buzz()
            }
        }
    }
    
    @Published var stringsLayoutChoice: StringsLayoutChoice = .guitar {
        willSet(newStringsLayoutChoice) {
            if newStringsLayoutChoice != stringsLayoutChoice {buzz()}
            if !self.latching {allPitchesNoteOff()}
        }
    }
    
    @Published var latching: Bool = false {
        willSet {
            externallyActivatedPitches.removeAll()
        }
    }
    
    @Published var tonicMIDI: Int {
        willSet(newTonicMIDI) {
            allPitches[tonicMIDI].isTonic = false
            allPitches[newTonicMIDI].isTonic = true
        }
    }
    
    var tonicPitch: Pitch {
        allPitches[ tonicMIDI]
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
    
    var centerMIDI: Int {
        tonicMIDI + (pitchDirection == .upward ? 6 : -6)
    }
    
    var lowMIDI: Int {
        Int(centerMIDI) - colsPerSide[self.layoutChoice]!
    }
    
    var highMIDI: Int {
        Int(centerMIDI) + colsPerSide[self.layoutChoice]!
    }
    
    let brownColor: CGColor = #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1)
    let creamColor: CGColor = #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1)
    
    var mainColor: Color {
        return Color(brownColor)
    }
    
    var openStringsMIDI: [Int] {
        stringsLayoutChoice.openStringsMIDI
    }
    
    func allPitchesNoteOff() {
        self.allPitches.forEach {pitch in
            pitch.noteOff()
        }
    }
    
    var isPaletteDefault: Bool {
        paletteChoices[layoutChoice] == ViewConductor.defaultPaletteChoices[layoutChoice]
    }
    
    func resetPaletteChoice() {
        paletteChoices[layoutChoice] = ViewConductor.defaultPaletteChoices[layoutChoice]
        buzz()
    }
    
    var areLabelsDefault: Bool {
        noteLabels[layoutChoice] == ViewConductor.defaultNoteLabels[layoutChoice] &&
        intervalLabels[layoutChoice] == ViewConductor.defaultIntervalLabels[layoutChoice] &&
        accidentalChoices[layoutChoice] == ViewConductor.defaultAccidentalChoices[layoutChoice]
    }
    
    func resetLabels() {
        resetNoteLabels()
        resetIntervalLabels()
        resetAccidentalChoice()
        buzz()
    }
    
    func resetNoteLabels() {
        noteLabels[layoutChoice] = ViewConductor.defaultNoteLabels[layoutChoice]
    }
    
    func resetIntervalLabels() {
        intervalLabels[layoutChoice] = ViewConductor.defaultIntervalLabels[layoutChoice]
    }
    
    func resetAccidentalChoice() {
        accidentalChoices[layoutChoice] = ViewConductor.defaultAccidentalChoices[layoutChoice]
    }
    
    func accidentalChoice() -> AccidentalChoice {
        return accidentalChoices[layoutChoice]!
    }
    
    @Published var accidentalChoices: [LayoutChoice: AccidentalChoice] = defaultAccidentalChoices
    
    static let defaultAccidentalChoices: [LayoutChoice: AccidentalChoice] = [
        .tonic: .flat,
        .isomorphic: .flat,
        .symmetric:  .flat,
        .piano:      .flat,
        .strings:     .flat
    ]
    
    var paletteChoice: PaletteChoice {
        paletteChoices[layoutChoice]!
    }
    
    @Published var paletteChoices: [LayoutChoice: PaletteChoice] = defaultPaletteChoices {
        willSet(newPaletteChoices) {
            if newPaletteChoices[layoutChoice]! != paletteChoices[layoutChoice]! {
                buzz()
            }
        }
    }
    
    static let defaultPaletteChoices: [LayoutChoice: PaletteChoice] = [
        .tonic:       .subtle,
        .isomorphic: .subtle,
        .symmetric:  .subtle,
        .piano:      .subtle,
        .strings:     .subtle
    ]
    
    @Published var noteLabels: [LayoutChoice: [NoteLabelChoice: Bool]] = ViewConductor.defaultNoteLabels
    
    static let defaultNoteLabels: [LayoutChoice: [NoteLabelChoice: Bool]] = [
        .tonic: [.letter: true, .fixedDo: false, .month: false, .octave: false, .mode: false, .plot: false, .midi: false , .frequency: false],
        .isomorphic: [.letter: false, .fixedDo: false, .month: false, .octave: false, .mode: false, .plot: false, .midi: false, .frequency: false],
        .symmetric: [.letter: false, .fixedDo: false, .month: false, .octave:  false, .mode: false, .plot: false, .midi: false, .frequency: false],
        .piano: [.letter: false, .fixedDo: false, .month: false, .octave:  false, .mode: false, .plot: false, .midi: false, .frequency: false],
        .strings: [.letter: false, .fixedDo: false, .month: false, .octave:  false, .mode: false, .plot: false, .midi: false, .frequency: false]
    ]
    
    @Published var intervalLabels: [LayoutChoice: [IntervalLabelChoice: Bool]] = ViewConductor.defaultIntervalLabels
    
    static let defaultIntervalLabels: [LayoutChoice: [IntervalLabelChoice: Bool]] = [
        .tonic: [.symbol: false, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false],
        .isomorphic: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false],
        .symmetric: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false],
        .piano: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false],
        .strings: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false]
    ]
    
    public func noteLabelBinding(for key: NoteLabelChoice) -> Binding<Bool> {
        return Binding(
            get: {
                return self.noteLabels[self.layoutChoice]![key] ?? false
            },
            set: {
                self.noteLabels[self.layoutChoice]![key] = $0
            }
        )
    }
    
    public func intervalLabelBinding(for key: IntervalLabelChoice) -> Binding<Bool> {
        return Binding(
            get: {
                return self.intervalLabels[self.layoutChoice]![key] ?? false
            },
            set: {
                self.intervalLabels[self.layoutChoice]![key] = $0
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
    
    @Published var pitchDirection: PitchDirection = .upward
    
    var showRowColsReset: Bool {
        colsPerSide[layoutChoice] != ViewConductor.defaultColsPerSide[layoutChoice] ||
        rowsPerSide[layoutChoice] != ViewConductor.defaultRowsPerSide[layoutChoice]
    }
    
    var showMoreRows: Bool {
        rowsPerSide[layoutChoice]! < ViewConductor.maxRowsPerSide[layoutChoice]!
    }
    
    var showFewerRows: Bool {
        rowsPerSide[layoutChoice]! > ViewConductor.minRowsPerSide[layoutChoice]!
    }

    var showFewerColumns: Bool {
        colsPerSide[layoutChoice]! > ViewConductor.minColsPerSide[layoutChoice]!
    }

    var showMoreColumns: Bool {
        colsPerSide[layoutChoice]! < ViewConductor.maxColsPerSide[layoutChoice]!
    }
    
    func resetRowsColsPerSide() {
        resetRowsPerSide()
        resetColsPerSide()
    }
    
    @Published var colsPerSide: [LayoutChoice: Int] = ViewConductor.defaultColsPerSide
    
    func resetColsPerSide() {
        colsPerSide[layoutChoice]! = ViewConductor.defaultColsPerSide[layoutChoice]!
    }
        
    static let defaultColsPerSide: [LayoutChoice: Int] = [
        .tonic:      6,
        .isomorphic: 9,
        .symmetric:  13,
        .piano:      13,
        .strings:    26
    ]
    
    static let minColsPerSide: [LayoutChoice: Int] = [
        .tonic:      6,
        .isomorphic: 6,
        .symmetric:  6,
        .piano:      6,
        .strings:    26
    ]

    static let maxColsPerSide: [LayoutChoice: Int] = [
        .tonic:      6,
        .isomorphic: 18,
        .symmetric:  18,
        .piano:      18,
        .strings:    26
    ]

    @Published var rowsPerSide: [LayoutChoice: Int] = ViewConductor.defaultRowsPerSide
    
    func resetRowsPerSide() {
        rowsPerSide[layoutChoice]! = ViewConductor.defaultRowsPerSide[layoutChoice]!
    }
        
    static let defaultRowsPerSide: [LayoutChoice: Int] = [
        .tonic:      0,
        .isomorphic: 0,
        .symmetric:  0,
        .piano:      0,
        .strings:    6
    ]
    
    static let minRowsPerSide: [LayoutChoice: Int] = [
        .tonic:      0,
        .isomorphic: 0,
        .symmetric:  0,
        .piano:      0,
        .strings:    4
    ]

    static let maxRowsPerSide: [LayoutChoice: Int] = [
        .tonic:      0,
        .isomorphic: 4,
        .symmetric:  2,
        .piano:      2,
        .strings:    26
    ]

    // KeyboardModel
    var keyRectInfos: [KeyRectInfo] = []
    var normalizedPoints = Array(repeating: CGPoint.zero, count: 128)
    
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
                    buzz()
                }
            }
        } else {
            for pitch in newPitches {
                pitch.noteOn()
            }
            for pitch in oldPitches {
                pitch.noteOff()
            }
        }
    }
}

