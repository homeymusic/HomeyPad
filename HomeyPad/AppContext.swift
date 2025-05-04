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
    private var instrumentTypeRaw: Int = Int(MusicalInstrumentType.default.rawValue)
    
    @ObservationIgnored
    @AppStorage("stringMusicalInstrumentType")
    private var stringMusicalInstrumentTypeRaw: Int = Int(MusicalInstrumentType.defaultStringMusicalInstrumentType.rawValue)
    
    public var beforeInstrumentChange: ((MusicalInstrumentType) -> Void)?
    public var afterInstrumentChange: ((MusicalInstrumentType) -> Void)?

    
    public var instrumentType: MusicalInstrumentType = MusicalInstrumentType.default {
        
        willSet {
            beforeInstrumentChange?(instrumentType)
        }
        
        didSet {
            instrumentTypeRaw = Int(instrumentType.rawValue)
            // Keep stringMusicalInstrumentType in sync if the instrument is a string.
            if instrumentType.isStringInstrument {
                stringMusicalInstrumentType = instrumentType
                stringMusicalInstrumentTypeRaw = Int(instrumentType.rawValue)
            }
            afterInstrumentChange?(instrumentType)
        }
    }
    
    public var stringMusicalInstrumentType: MusicalInstrumentType  = MusicalInstrumentType.defaultStringMusicalInstrumentType {
        didSet {
            stringMusicalInstrumentTypeRaw = Int(stringMusicalInstrumentType.rawValue)
        }
    }
    
    public init() {
        self.instrumentType = MusicalInstrumentType(rawValue: instrumentTypeRaw) ?? MusicalInstrumentType.default
        self.stringMusicalInstrumentType = MusicalInstrumentType(rawValue: stringMusicalInstrumentTypeRaw) ?? MusicalInstrumentType.defaultStringMusicalInstrumentType
    }
}
