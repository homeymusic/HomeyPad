import SwiftUI

class ViewConductor: ObservableObject {
    
    var allPitches = [Pitch]()
    
    init() {
        for midi: Int8 in 0...127 {
            allPitches.append(Pitch(midi))
        }
    }
    
    @Published var layoutChoice: LayoutChoice = .isomorphic  {
        willSet { if !self.latching {allPitchesNoteOff()}}
    }
    
    func allPitchesNoteOff() {
        self.allPitches.forEach {pitch in
            pitch.noteOff()
        }
    }
    
    @Published var paletteChoice: [LayoutChoice: PaletteChoice] = [
        .isomorphic: .subtle,
        .symmetric:  .subtle,
        .piano:      .subtle,
        .guitar:     .subtle
    ]

    @Published var noteLabels: [LayoutChoice: [NoteLabelChoice: Bool]] = [
        .isomorphic: [.letter: false, .fixedDo: false, .month: false, .midi: false, .frequency: false],
        .symmetric: [.letter: false, .fixedDo: false, .month: false, .midi: false, .frequency: false],
        .piano: [.letter: false, .fixedDo: false, .month: false, .midi: false, .frequency: false],
        .guitar: [.letter: false, .fixedDo: false, .month: false, .midi: false, .frequency: false]
    ]

    @Published var intervalLabels: [LayoutChoice: [IntervalLabelChoice: Bool]] = [
        .isomorphic: [.interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false],
        .symmetric: [.interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false],
        .piano: [.interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false],
        .guitar: [.interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false]
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
    
    @Published var showSymbols: Bool = true
    
    @Published var showKeyLabelsPopover: Bool = false
    
    @Published var showPalettePopover: Bool = false
    
    @Published var showTonicPicker: Bool = false
    
    @Published var latching: Bool = false {
        willSet(newValue) {
            if !newValue {allPitchesNoteOff()}
        }
    }
    
    @Published var headerFooterPadding: CGFloat = 35.0
    
    @Published var tonicMIDI: Int = 60
    
    @Published var lowMIDI: [LayoutChoice: Int] = [
        .isomorphic: 57,
        .symmetric:  53,
        .piano:      53,
        .guitar:     40
    ]
    
    @Published var highMIDI: [LayoutChoice: Int] = [
        .isomorphic: 75,
        .symmetric:  79,
        .piano:      79,
        .guitar:     86
    ]
    
    var tonicPitch: Pitch {
        self.allPitches[self.tonicMIDI]
    }
    
    var pitches: ArraySlice<Pitch> {
        return allPitches[lowMIDI[self.layoutChoice]!...highMIDI[self.layoutChoice]!]
    }
    
}

