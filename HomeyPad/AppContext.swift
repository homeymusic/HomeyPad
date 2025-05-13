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
    private var instrumentTypeRaw: Int = Int(MIDIInstrumentType.default.rawValue)
    
    @ObservationIgnored
    @AppStorage("stringMusicalInstrumentType")
    private var stringMusicalInstrumentTypeRaw: Int = Int(MIDIInstrumentType.defaultStringMusicalInstrumentType.rawValue)
    
    public var beforeInstrumentChange: ((MIDIInstrumentType) -> Void)?
    public var afterInstrumentChange: ((MIDIInstrumentType) -> Void)?

    
    public var instrumentType: MIDIInstrumentType = MIDIInstrumentType.default {
        
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
    
    public var stringMusicalInstrumentType: MIDIInstrumentType  = MIDIInstrumentType.defaultStringMusicalInstrumentType {
        didSet {
            stringMusicalInstrumentTypeRaw = Int(stringMusicalInstrumentType.rawValue)
        }
    }
    
    public init() {
        self.instrumentType = MIDIInstrumentType(rawValue: instrumentTypeRaw) ?? MIDIInstrumentType.default
        self.stringMusicalInstrumentType = MIDIInstrumentType(rawValue: stringMusicalInstrumentTypeRaw) ?? MIDIInstrumentType.defaultStringMusicalInstrumentType
    }
}
