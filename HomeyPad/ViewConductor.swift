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
    
    @Published var layoutChoice: LayoutChoice = .isomorphic  {
        willSet { if !self.latching {allPitchesNoteOff()}}
    }
    
    func allPitchesNoteOff() {
        self.allPitches.forEach {pitch in
            pitch.noteOff()
        }
    }
    
    var paletteChoice: PaletteChoice {
        paletteChoices[layoutChoice]!
    }
    
    @Published var paletteChoices: [LayoutChoice: PaletteChoice] = [
        .isomorphic: .subtle,
        .symmetric:  .subtle,
        .piano:      .subtle,
        .guitar:     .subtle
    ]
    
    @Published var noteLabels: [LayoutChoice: [NoteLabelChoice: Bool]] = [
        .isomorphic: [.letter: false, .fixedDo: false, .month: false, .octave: true, .midi: false, .frequency: false],
        .symmetric: [.letter: false, .fixedDo: false, .month: false, .octave: true, .midi: false, .frequency: false],
        .piano: [.letter: false, .fixedDo: false, .month: false, .octave: true, .midi: false, .frequency: false],
        .guitar: [.letter: false, .fixedDo: false, .month: false, .octave: true, .midi: false, .frequency: false]
    ]
    
    @Published var intervalLabels: [LayoutChoice: [IntervalLabelChoice: Bool]] = [
        .isomorphic: [.interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false, .symbol: true],
        .symmetric: [.interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false, .symbol: true],
        .piano: [.interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false, .symbol: true],
        .guitar: [.interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false, .symbol: true]
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
    
    @Published var showKeyLabelsPopover: Bool = false
    
    @Published var showPalettePopover: Bool = false
    
    @Published var showTonicPicker: Bool = false
    
    @Published var latching: Bool = false {
        willSet(newValue) {
            if !newValue {allPitchesNoteOff()}
        }
    }
    
    @Published var pitchDirection: PitchDirection = .upward
    
    let initialCenterMIDI: Int = 66
    
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
        .isomorphic: 9,
        .symmetric:  13,
        .piano:      13,
        .guitar:     26
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
