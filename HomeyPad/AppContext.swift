import SwiftUI
import HomeyMusicKit

@MainActor
@Observable
public final class AppContext {
    public var showModePicker: Bool = false
    public var showTonicPicker: Bool = false
    public var showLabelsPopover: Bool = false
    public var showColorPalettePopover: Bool = false
    public var showEditColorPaletteSheet: Bool = false
    public var showTonicModeLabelsPopover: Bool = false
    public var showHelp: Bool = false
    @ObservationIgnored
    @AppStorage("instrumentChoice")
    private var instrumentChoiceRaw: Int = Int(InstrumentChoice.default.rawValue)
    
    @ObservationIgnored
    @AppStorage("stringInstrumentChoice")
    private var stringInstrumentChoiceRaw: Int = Int(InstrumentChoice.defaultStringInstrumentChoice.rawValue)
    
    public var beforeInstrumentChange: ((InstrumentChoice) -> Void)?
    public var afterInstrumentChange: ((InstrumentChoice) -> Void)?

    public var instrumentChoice: InstrumentChoice = InstrumentChoice.default {
        
        willSet {
            beforeInstrumentChange?(instrumentChoice)
        }
        
        didSet {
            instrumentChoiceRaw = Int(instrumentChoice.rawValue)
            // Keep stringInstrumentChoice in sync if the instrument is a string.
            if instrumentChoice.isStringInstrument {
                stringInstrumentChoice = instrumentChoice
                stringInstrumentChoiceRaw = Int(instrumentChoice.rawValue)
            }
            afterInstrumentChange?(instrumentChoice)
        }
    }
    
    public var stringInstrumentChoice: InstrumentChoice  = InstrumentChoice.defaultStringInstrumentChoice {
        didSet {
            stringInstrumentChoiceRaw = Int(stringInstrumentChoice.rawValue)
        }
    }
    
    public init() {
        self.instrumentChoice = InstrumentChoice(rawValue: instrumentChoiceRaw) ?? InstrumentChoice.default
        self.stringInstrumentChoice = InstrumentChoice(rawValue: stringInstrumentChoiceRaw) ?? InstrumentChoice.defaultStringInstrumentChoice
    }
}
