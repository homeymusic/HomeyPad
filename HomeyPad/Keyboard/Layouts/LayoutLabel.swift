struct LayoutLabel: Codable, Equatable {
    
    var noteLabelChoices: [LayoutChoice: [NoteLabelChoice: Bool]] = defaultNoteLabels
    
    static let defaultNoteLabels: [LayoutChoice: [NoteLabelChoice: Bool]] = [
        .tonic: [.letter: true, .fixedDo: false, .month: false, .octave: false, .mode: false, .plot: false, .midi: false , .frequency: false],
        .isomorphic: [.letter: false, .fixedDo: false, .month: false, .octave: false, .mode: false, .plot: false, .midi: false, .frequency: false],
        .symmetric: [.letter: false, .fixedDo: false, .month: false, .octave:  false, .mode: false, .plot: false, .midi: false, .frequency: false],
        .piano: [.letter: false, .fixedDo: false, .month: false, .octave:  false, .mode: false, .plot: false, .midi: false, .frequency: false],
        .strings: [.letter: false, .fixedDo: false, .month: false, .octave:  false, .mode: false, .plot: false, .midi: false, .frequency: false]
    ]
 
    var intervalLabelChoices: [LayoutChoice: [IntervalLabelChoice: Bool]] = defaultIntervalLabels

    static let defaultIntervalLabels: [LayoutChoice: [IntervalLabelChoice: Bool]] = [
        .tonic: [.symbol: false, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false],
        .isomorphic: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false],
        .symmetric: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false],
        .piano: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false],
        .strings: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false]
    ]
    

}
