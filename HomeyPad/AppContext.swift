import SwiftUI
import SwiftData
import HomeyMusicKit

@MainActor
@Observable
public final class AppContext {
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
    @AppStorage("stringMusicalInstrumentType")
    private var stringMusicalInstrumentTypeRaw: Int = Int(InstrumentType.defaultStringMusicalInstrumentType.rawValue)
    
    public var beforeInstrumentChange: ((InstrumentType) -> Void)?
    public var afterInstrumentChange: ((InstrumentType) -> Void)?

    
    public var instrumentType: InstrumentType = InstrumentType.default {
        
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
    
    public var stringMusicalInstrumentType: InstrumentType  = InstrumentType.defaultStringMusicalInstrumentType {
        didSet {
            stringMusicalInstrumentTypeRaw = Int(stringMusicalInstrumentType.rawValue)
        }
    }
    
    public init() {
        self.instrumentType = InstrumentType(rawValue: instrumentTypeRaw) ?? InstrumentType.default
        self.stringMusicalInstrumentType = InstrumentType(rawValue: stringMusicalInstrumentTypeRaw) ?? InstrumentType.defaultStringMusicalInstrumentType
    }
}
