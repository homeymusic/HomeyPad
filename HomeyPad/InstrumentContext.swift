import SwiftUI
import HomeyMusicKit

final class InstrumentContext: ObservableObject {
    let appDefaults = UserDefaults.standard

    @Published var layoutChoice: LayoutChoice
    @Published var stringsLayoutChoice: StringsLayoutChoice
    @Published var instrumentType: InstrumentType = .zeena {
        didSet {
            print("instrumentType didSet:", instrumentType)
            if instrumentType.isStringInstrument {
                stringInstrumentType = instrumentType
            }
        }
    }
    @Published var stringInstrumentType: InstrumentType = .banjo

    // Dictionary mapping instrument types to instrument instances.
    private(set) var instrumentByType: [InstrumentType: Instrument] = {
        InstrumentType.allCases.reduce(into: [InstrumentType: Instrument]()) { mapping, instrumentType in
            switch instrumentType {
            case .isomorphic:
                mapping[instrumentType] = Isomorphic()
            case .zeena:
                mapping[instrumentType] = Zeena()
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
            }
        }
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
        let defaultLayoutChoice: LayoutChoice = .zeena
        
        appDefaults.register(defaults: [
            "layoutChoice": defaultLayoutChoice.rawValue
        ])
        
        self.layoutChoice = LayoutChoice(
            rawValue: appDefaults.string(forKey: "layoutChoice") ?? defaultLayoutChoice.rawValue
        ) ?? defaultLayoutChoice
        
        let defaultStringsLayoutChoice: StringsLayoutChoice = .violin
        appDefaults.register(defaults: [
            "stringsLayoutChoice": defaultStringsLayoutChoice.rawValue
        ])
        self.stringsLayoutChoice = StringsLayoutChoice(
            rawValue: appDefaults.string(forKey: "stringsLayoutChoice") ?? defaultStringsLayoutChoice.rawValue
        ) ?? defaultStringsLayoutChoice
    }
    
    public var instruments: [InstrumentType] {
        InstrumentType.keyboardInstruments + [self.stringInstrumentType]
    }
}
