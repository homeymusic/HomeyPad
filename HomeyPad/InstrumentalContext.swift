import SwiftUI
import HomeyMusicKit

final class InstrumentalContext: ObservableObject {
    @Published var instrumentType: InstrumentType {
        didSet {
            if instrumentType.isStringInstrument {
                stringInstrumentType = instrumentType
            }
        }
    }
    @Published var stringInstrumentType: InstrumentType
        
    private(set) var instrumentByType: [InstrumentType: Instrument] = {
        var mapping: [InstrumentType: Instrument] = [:]
        InstrumentType.allCases.forEach { instrumentType in
            switch instrumentType {
            case .isomorphic:
                mapping[instrumentType] = Isomorphic()
            case .diamanti:
                mapping[instrumentType] = Diamanti()
            case .piano:
                mapping[instrumentType] = Piano()
            case .violin:
                mapping[instrumentType] = Violin()
            case .cello:
                mapping[instrumentType] = Cello()
            case .bass:
                mapping[instrumentType] = Bass()
            case .banjo:
                mapping[instrumentType] = Banjo()
            case .guitar:
                mapping[instrumentType] = Guitar()
            case .tonicPicker:
                mapping[instrumentType] = TonicPicker()
            }
        }
        return mapping
    }()
    
    /// Returns the current instrument instance based on instrumentType.
    public var instrument: Instrument {
        guard let inst = instrumentByType[instrumentType] else {
            fatalError("No instrument instance found for \(instrumentType)")
        }
        return inst
    }
    
    /// Returns the current keyboard instrument.
    public var keyboardInstrument: KeyboardInstrument {
        guard let inst = instrumentByType[instrumentType] as? KeyboardInstrument else {
            fatalError("No keyboard instrument instance found for \(instrumentType)")
        }
        return inst
    }
    
    init() {
        self.instrumentType = .diamanti
        self.stringInstrumentType = .violin
    }
    
    public var instruments: [InstrumentType] {
        InstrumentType.keyboardInstruments + [self.stringInstrumentType]
    }
}
