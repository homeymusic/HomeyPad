import SwiftUI
import MIDIKit
import HomeyMusicKit

@MainActor
class ViewConductor: ObservableObject {
    
    init(accidental: Accidental, layoutChoice: LayoutChoice, stringsLayoutChoice: StringsLayoutChoice = StringsLayoutChoice.violin, latching: Bool = false, layoutPalette: LayoutPalette = LayoutPalette(), layoutLabel: LayoutLabel = LayoutLabel(), layoutRowsCols: LayoutRowsCols = LayoutRowsCols(), sendTonicState: Bool = false) {
        // defaults
        self.accidental          = accidental
        self.layoutChoice        = layoutChoice
        self.stringsLayoutChoice = stringsLayoutChoice
        self.latching            = latching
        self.layoutPalette       = layoutPalette
        self.layoutLabel         = layoutLabel
        self.layoutRowsCols      = layoutRowsCols
    }
    
    @StateObject private var tonalContext = TonalContext.shared

    let animationStyle: Animation = Animation.linear
    
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
    
    public var layoutNotes: ClosedRange<Int> {
        let tritoneSemitones = tonalContext.pitchDirection == .downward ? -6 : +6
        let lowerBound: Int = Int(tonalContext.tonicMIDI) + tritoneSemitones - layoutRowsCols.colsPerSide[self.layoutChoice]!
        let upperBound: Int = Int(tonalContext.tonicMIDI) + tritoneSemitones + layoutRowsCols.colsPerSide[self.layoutChoice]!
        return lowerBound ... upperBound
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
    
    var midiChannel: MIDIChannel {
        layoutChoice.midiChannel(stringsLayoutChoice: stringsLayoutChoice)
    }
    
    func allPitchesNoteOff(layoutChoice: LayoutChoice, stringsLayoutChoice: StringsLayoutChoice) {
        Pitch.allPitches.forEach {pitch in
            pitch.deactivate(midiChannel: midiChannel)
        }
    }
    
    func activePitchesNoteOn(activePitches: Set<Pitch>) {
        activePitches.forEach {pitch in
            pitch.activate(midiChannel: midiChannel)
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
    
    // Add a flag to lock the tonic during a touch event (private)
    private var isTonicLocked = false

    var touchLocations: [CGPoint] = [] {
        didSet {
            var newPitches = Set<Pitch>()
            
            for location in touchLocations {
                var pitch: Pitch?
                var highestZindex = -1
                var normalizedPoint = CGPoint.zero
                
                // Loop through keyRectInfos and find the highest Z-index pitch
                for info in keyRectInfos where info.rect.contains(location) {
                    if pitch == nil || info.zIndex > highestZindex {
                        pitch = info.pitch
                        highestZindex = info.zIndex
                        normalizedPoint = CGPoint(x: (location.x - info.rect.minX) / info.rect.width,
                                                  y: (location.y - info.rect.minY) / info.rect.height)
                    }
                }
                
                // In tonic mode, lock the tonic after the first touch and ignore further changes
                if layoutChoice == .tonic {
                    if let p = pitch, !isTonicLocked {
                        newPitches.insert(p)  // Add the first touch to newPitches
                        normalizedPoints[p.intValue] = normalizedPoint
                        isTonicLocked = true  // Lock the tonic for the duration of this touch
                    }
                } else {
                    // For non-tonic modes, allow glissando behavior (multiple touches)
                    if let p = pitch {
                        newPitches.insert(p)
                        normalizedPoints[p.intValue] = normalizedPoint
                    }
                }
            }

            // Only update touchedPitches if there are changes
            if touchedPitches != newPitches {
                touchedPitches = newPitches
            }

            // Unlock the tonic when no more touch locations are active (touch ends)
            if touchLocations.isEmpty {
                isTonicLocked = false
            }
        }
    }
    
    /// all touched notes
    @Published public var touchedPitches = Set<Pitch>() {
        didSet {
            self.triggerEvents(from: oldValue, to: touchedPitches)
        }
    }
    
    /// Either latched keys or keys active due to external MIDI events.
    @Published public var externallyActivatedPitches = Set<Pitch>() {
        didSet {
            self.triggerEvents(from: oldValue, to: self.externallyActivatedPitches)
        }
    }
        
    @Published var accidental: Accidental = .default {
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
                let newTonicPitch = pitch
                if newTonicPitch != self.tonalContext.tonicPitch {
                    if newTonicPitch.isOctave(relativeTo: self.tonalContext.tonicPitch) {
                        if newTonicPitch.midiNote.number > self.tonalContext.tonicPitch.midiNote.number {
                            self.tonalContext.pitchDirection = .downward
                        } else {
                            self.tonalContext.pitchDirection = .upward
                        }
                    }
                    self.tonalContext.tonicPitch = newTonicPitch
                }
            }
        } else {
            for pitch in newPitches {
                pitch.activate(midiChannel: midiChannel)
            }
            for pitch in oldPitches {
                pitch.deactivate(midiChannel: midiChannel)
            }
        }
    }

    func tritoneLength(proxySize: CGSize) -> CGFloat {
        return min(proxySize.height * 1/3, proxySize.width)
    }
    
}

