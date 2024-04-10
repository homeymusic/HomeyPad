import SwiftUI

class ViewConductor: ObservableObject {
    
    var allPitches = [Pitch]()
    let brownColor: CGColor = #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1)
    let creamColor: CGColor = #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1)

    init() {
        for midi: Int8 in 0...127 {
            allPitches.append(Pitch(midi))
        }
    }
    
    var houseIcon: String {
        "house"
    }
    
    var mainColor: Color {
        return Color(brownColor)
    }
    
    var accentColor: Color {
        switch paletteChoice {
        case .subtle:
            Color(creamColor)
        case .loud:
            Color(brownColor)
        case .ebonyIvory:
            Color(brownColor)
        }
    }

    let backgroundColor: Color = .black
    
    @Published var layoutChoice: LayoutChoice = .isomorphic {
        willSet { if !self.latching {allPitchesNoteOff()}}
    }
    
    @Published var stringsLayoutChoice: StringsLayoutChoice = .guitar {
        willSet { if !self.latching {allPitchesNoteOff()}}
    }

    var openStringsMIDI: [Int] {
        stringsLayoutChoice.openStringsMIDI
    }
    
    func allPitchesNoteOff() {
        self.allPitches.forEach {pitch in
            pitch.noteOff()
        }
    }
    
    func resetLabels(homeLayout: Bool = false) {
        resetNoteLabels(homeLayout: homeLayout)
        resetIntervalLabels(homeLayout: homeLayout)
        resetAccidentalChoice(homeLayout: homeLayout)
    }

    func resetPaletteChoice(homeLayout: Bool = false) {
        let layout = homeLayout ? .home : layoutChoice
        paletteChoices[layout] = ViewConductor.defaultPaletteChoices[layout]
    }

    func resetAccidentalChoice(homeLayout: Bool = false) {
        let layout = homeLayout ? .home : layoutChoice
        accidentalChoices[layout] = ViewConductor.defaultAccidentalChoices[layout]
    }

    func resetNoteLabels(homeLayout: Bool = false) {
        let layout = homeLayout ? .home : layoutChoice
        noteLabels[layout] = ViewConductor.defaultNoteLabels[layout]
    }
    
    func resetIntervalLabels(homeLayout: Bool = false) {
        let layout = homeLayout ? .home : layoutChoice
        intervalLabels[layout] = ViewConductor.defaultIntervalLabels[layout]
    }

    func accidentalChoice(homeLayout: Bool = false) -> AccidentalChoice {
        let layout = homeLayout ? .home : layoutChoice
        return accidentalChoices[layout]!
    }

    @Published var accidentalChoices: [LayoutChoice: AccidentalChoice] = defaultAccidentalChoices
    
    static let defaultAccidentalChoices: [LayoutChoice: AccidentalChoice] = [
        .home: .flat,
        .isomorphic: .flat,
        .symmetric:  .flat,
        .piano:      .flat,
        .strings:     .flat
    ]
    
    var paletteChoice: PaletteChoice {
        paletteChoices[layoutChoice]!
    }
    
    @Published var paletteChoices: [LayoutChoice: PaletteChoice] = defaultPaletteChoices
    
    static let defaultPaletteChoices: [LayoutChoice: PaletteChoice] = [
        .home:       .subtle,
        .isomorphic: .subtle,
        .symmetric:  .subtle,
        .piano:      .subtle,
        .strings:     .subtle
    ]
    
    @Published var noteLabels: [LayoutChoice: [NoteLabelChoice: Bool]] = ViewConductor.defaultNoteLabels
    
    static let defaultNoteLabels: [LayoutChoice: [NoteLabelChoice: Bool]] = [
        .home: [.letter: false, .fixedDo: false, .month: false, .octave: false, .midi: false, .frequency: false],
        .isomorphic: [.letter: false, .fixedDo: false, .month: false, .octave: false, .midi: false, .frequency: false],
        .symmetric: [.letter: false, .fixedDo: false, .month: false, .octave:  false, .midi: false, .frequency: false],
        .piano: [.letter: false, .fixedDo: false, .month: false, .octave:  false, .midi: false, .frequency: false],
        .strings: [.letter: false, .fixedDo: false, .month: false, .octave:  false, .midi: false, .frequency: false]
    ]
    
    @Published var intervalLabels: [LayoutChoice: [IntervalLabelChoice: Bool]] = ViewConductor.defaultIntervalLabels
    
    static let defaultIntervalLabels: [LayoutChoice: [IntervalLabelChoice: Bool]] = [
        .home: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false],
        .isomorphic: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false],
        .symmetric: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false],
        .piano: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false],
        .strings: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false]
    ]
    
    public func noteLabelBinding(for key: NoteLabelChoice, homeLayout: Bool = false) -> Binding<Bool> {
        let layout: LayoutChoice = homeLayout ? .home : self.layoutChoice
        return Binding(
            get: {
                return self.noteLabels[layout]![key] ?? false
            },
            set: {
                self.noteLabels[layout]![key] = $0
            }
        )
    }
    
    public func intervalLabelBinding(for key: IntervalLabelChoice, homeLayout: Bool = false) -> Binding<Bool> {
        let layout: LayoutChoice = homeLayout ? .home : self.layoutChoice
        return Binding(
            get: {
                return self.intervalLabels[layout]![key] ?? false
            },
            set: {
                self.intervalLabels[layout]![key] = $0
            }
        )
    }
    
    var showSymbols: Bool {
        intervalLabels[layoutChoice]![.symbol]!
    }
    
    func enableAccidentalPicker(homeLayout: Bool = false) -> Bool {
        let layout = homeLayout ? .home : layoutChoice
        return noteLabels[layout]![.letter]! ||
        noteLabels[layout]![.fixedDo]!
    }
    
    func enableOctavePicker(homeLayout: Bool = false) -> Bool {
        let layout = homeLayout ? .home : layoutChoice
        return noteLabels[layout]![.letter]! ||
        noteLabels[layout]![.fixedDo]! ||
        noteLabels[layout]![.month]!
    }

    @Published var showKeyLabelsPopover: Bool = false
    
    @Published var showTonicKeyLabelsPopover: Bool = false
    
    @Published var showPalettePopover: Bool = false
    
    @Published var showTonicPalettePopover: Bool = false
    
    @Published var showTonicPicker: Bool = false
    
    @Published var latching: Bool = false {
        willSet(newValue) {
            if !newValue {allPitchesNoteOff()}
        }
    }
    
    @Published var pitchDirection: PitchDirection = .upward
    
    @Published var initialCenterMIDI: Int = 66
    
    let octaveShiftRange: ClosedRange<Int8> = Int8(-5)...Int8(+5)
    
    @Published var octaveShift: Int8 = 0 {
        willSet(newOctaveShift) {assert(octaveShiftRange.contains(newOctaveShift))}
    }
    
    var centerMIDI: Int
    {
        initialCenterMIDI + Int(octaveShift) * 12
    }
    
    var tonicMIDI: Int {
        centerMIDI + (pitchDirection == .upward ? -6 : +6)
    }
    
    var tonicPitch: Pitch {
        self.allPitches[Int(self.tonicMIDI)]
    }
    
    @Published var midiPerSide: [LayoutChoice: Int] = [
        .home: 6,
        .isomorphic: 9,
        .symmetric:  13,
        .piano:      13,
        .strings:     26
    ]
    
    var lowMIDI: Int {
        Int(centerMIDI) - midiPerSide[self.layoutChoice]!
    }
    
    var highMIDI: Int {
        Int(centerMIDI) + midiPerSide[self.layoutChoice]!
    }
    
    var pitches: ArraySlice<Pitch> {
        return allPitches[lowMIDI...highMIDI]
    }
    
    
}

enum PitchDirection: Int8, CaseIterable, Identifiable {
    case upward    = 1
    case ambiguous = 0
    case downward  = -1
    
    var id: Int8 { self.rawValue }
}
