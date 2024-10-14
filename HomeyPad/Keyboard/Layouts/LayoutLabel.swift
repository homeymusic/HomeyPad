import HomeyMusicKit

struct LayoutLabel: Codable, Equatable {
    
    var noteLabelChoices: [LayoutChoice: [NoteLabelChoice: Bool]] = LayoutLabel.defaultNoteLabels
    var intervalLabelChoices: [LayoutChoice: [IntervalLabelChoice: Bool]] = LayoutLabel.defaultIntervalLabels

    // Static properties that hold default note and interval labels
    static let defaultNoteLabels: [LayoutChoice: [NoteLabelChoice: Bool]] = LayoutLabel.generateDefaultNoteLabels()
    static let defaultIntervalLabels: [LayoutChoice: [IntervalLabelChoice: Bool]] = LayoutLabel.generateDefaultIntervalLabels()

    // Helper function to generate default note label choices
    static func generateDefaultNoteLabels() -> [LayoutChoice: [NoteLabelChoice: Bool]] {
        let commonDefaultValues: [NoteLabelChoice: Bool] = [
            .letter: false, .fixedDo: false, .month: false, .octave: false,
            .mode: false, .plot: false, .midi: false, .frequency: false,
            .period: false, .wavelength: false, .wavenumber: false, .cochlea: false
        ]
        
        var defaultLabels = LayoutLabel.generateLayoutChoices(commonDefaultValues)
        
        // Customize for tonic to set .letter to true
        defaultLabels[.tonic]?[.letter] = true
        
        return defaultLabels
    }
    
    // Helper function to generate default interval label choices
    static func generateDefaultIntervalLabels() -> [LayoutChoice: [IntervalLabelChoice: Bool]] {
        let commonDefaultValues: [IntervalLabelChoice: Bool] = [
            .symbol: true, .interval: false, .movableDo: false, .roman: false,
            .degree: false, .integer: false, .frequencyRatio: false,
            .wavelengthRatio: false, .wavenumberRatio: false, .periodRatio: false
        ]
        
        return LayoutLabel.generateLayoutChoices(commonDefaultValues)
    }
    
    // Generic helper function to generate layout choices for any label type
    static func generateLayoutChoices<T: Hashable>(_ defaultValues: [T: Bool]) -> [LayoutChoice: [T: Bool]] {
        let layouts: [LayoutChoice] = [.tonic, .isomorphic, .symmetric, .piano, .strings]
        var choices: [LayoutChoice: [T: Bool]] = [:]
        
        for layout in layouts {
            choices[layout] = defaultValues
        }
        
        return choices
    }
}
