import SwiftUI
import SwiftData
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
    
    
    public var latchedMIDINoteNumbers: [MIDINoteNumber] = []
    
    @ObservationIgnored
    @AppStorage("instrumentType")
    private var instrumentTypeRaw: Int = Int(InstrumentType.default.rawValue)
    
    @ObservationIgnored
    @AppStorage("stringInstrumentType")
    private var stringInstrumentTypeRaw: Int = Int(InstrumentType.defaultStringInstrumentType.rawValue)
    
    public var beforeInstrumentChange: ((InstrumentType) -> Void)?
    public var afterInstrumentChange: ((InstrumentType) -> Void)?

    
    public var instrumentType: InstrumentType = InstrumentType.default {
        
        willSet {
            beforeInstrumentChange?(instrumentType)
        }
        
        didSet {
            instrumentTypeRaw = Int(instrumentType.rawValue)
            // Keep stringInstrumentType in sync if the instrument is a string.
            if instrumentType.isStringInstrument {
                stringInstrumentType = instrumentType
                stringInstrumentTypeRaw = Int(instrumentType.rawValue)
            }
            afterInstrumentChange?(instrumentType)
        }
    }
    
    public var stringInstrumentType: InstrumentType  = InstrumentType.defaultStringInstrumentType {
        didSet {
            stringInstrumentTypeRaw = Int(stringInstrumentType.rawValue)
        }
    }
    
    public init() {
        self.instrumentType = InstrumentType(rawValue: instrumentTypeRaw) ?? InstrumentType.default
        self.stringInstrumentType = InstrumentType(rawValue: stringInstrumentTypeRaw) ?? InstrumentType.defaultStringInstrumentType
    }
}
