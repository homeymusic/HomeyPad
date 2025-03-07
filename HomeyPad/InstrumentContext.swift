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
        InstrumentType.keyboardInstruments.reduce(into: [InstrumentType: Instrument]()) { mapping, instrumentType in
            switch instrumentType {
            case .isomorphic:
                mapping[instrumentType] = Isomorphic()
            case .zeena:
                mapping[instrumentType] = Zeena()
            case .piano:
                mapping[instrumentType] = Piano()
            default:
                break
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
    
    /// Convenience property to get the Zeena instance.
    public var isomorphic: Isomorphic {
        guard let inst = instrumentByType[.isomorphic] as? Isomorphic else {
            fatalError("No Isomorhpic instrument instance available")
        }
        return inst
    }
    
    public var zeena: Zeena {
        guard let inst = instrumentByType[.zeena] as? Zeena else {
            fatalError("No Zeena instrument instance available")
        }
        return inst
    }
    
    public var piano: Piano {
        guard let inst = instrumentByType[.piano] as? Piano else {
            fatalError("No Piano instrument instance available")
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
