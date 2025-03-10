import SwiftUI
import HomeyMusicKit

final class InstrumentalContext: ObservableObject {
    @Published var layoutChoice: LayoutChoice
    @Published var stringsLayoutChoice: StringsLayoutChoice
    @Published var instrumentType: InstrumentType = .diamanti {
        didSet {
            if instrumentType.isStringInstrument {
                stringInstrumentType = instrumentType
            }
        }
    }
    @Published var stringInstrumentType: InstrumentType = .banjo

    private(set) var instrumentByType: [InstrumentType: Instrument] = {
        Dictionary(uniqueKeysWithValues: InstrumentType.allCases.map { ($0, $0.instrument) })
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
        self.layoutChoice = LayoutChoice.diamanti
        
        self.stringsLayoutChoice = StringsLayoutChoice.violin
    }
    
    public var instruments: [InstrumentType] {
        InstrumentType.keyboardInstruments + [self.stringInstrumentType]
    }
}
