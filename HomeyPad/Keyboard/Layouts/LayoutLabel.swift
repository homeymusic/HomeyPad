struct LayoutLabel: Codable, Equatable {
    
    var noteLabelChoices: [LayoutChoice: [NoteLabelChoice: Bool]] = defaultNoteLabels
    
    static let defaultNoteLabels: [LayoutChoice: [NoteLabelChoice: Bool]] = [
        .tonic: [.letter: true, .fixedDo: false, .month: false, .octave: false, .mode: false, .plot: false, .midi: false, .frequency: false, .period: false, .wavelength: false, .wavenumber: false, .cochlea: false],
        .isomorphic: [.letter: false, .fixedDo: false, .month: false, .octave: false, .mode: false, .plot: false, .midi: false, .frequency: false, .period: false, .wavelength: false, .wavenumber: false, .cochlea: false],
        .dualistic: [.letter: false, .fixedDo: false, .month: false, .octave:  false, .mode: false, .plot: false, .midi: false, .frequency: false, .period: false, .wavelength: false, .wavenumber: false, .cochlea: false],
        .piano: [.letter: false, .fixedDo: false, .month: false, .octave:  false, .mode: false, .plot: false, .midi: false, .frequency: false, .period: false, .wavelength: false, .wavenumber: false, .cochlea: false],
        .strings: [.letter: false, .fixedDo: false, .month: false, .octave:  false, .mode: false, .plot: false, .midi: false, .frequency: false, .period: false, .wavelength: false, .wavenumber: false, .cochlea: false]
    ]
 
    var intervalLabelChoices: [LayoutChoice: [IntervalLabelChoice: Bool]] = defaultIntervalLabels

    static let defaultIntervalLabels: [LayoutChoice: [IntervalLabelChoice: Bool]] = [
        .tonic: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false, .frequencyRatio: false, .wavelengthRatio: false, .wavenumberRatio: false, .periodRatio: false],
        .isomorphic: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false, .frequencyRatio: false, .wavelengthRatio: false, .wavenumberRatio: false, .periodRatio: false],
        .dualistic: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false, .frequencyRatio: false, .wavelengthRatio: false, .wavenumberRatio: false, .periodRatio: false],
        .piano: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false, .frequencyRatio: false, .wavelengthRatio: false, .wavenumberRatio: false, .periodRatio: false],
        .strings: [.symbol: true, .interval: false, .movableDo: false, .roman: false, .degree: false, .integer: false, .frequencyRatio: false, .wavelengthRatio: false, .wavenumberRatio: false, .periodRatio: false]
    ]
    
}
