import SwiftData
import HomeyMusicKit

public extension ModelContext {
    private static let sharedSynthConductor = SynthConductor()
    
    @MainActor
    func instrument(for choice: InstrumentChoice) -> any Instrument {
        let instrument: any Instrument = switch choice {
        case .linear:     fetchOrCreate(Linear.self)      { Linear() }
        case .tonnetz:    fetchOrCreate(Tonnetz.self)     { Tonnetz() }
        case .diamanti:   fetchOrCreate(Diamanti.self)    { Diamanti() }
        case .piano:      fetchOrCreate(Piano.self)       { Piano() }
        case .violin:     fetchOrCreate(Violin.self)      { Violin() }
        case .cello:      fetchOrCreate(Cello.self)       { Cello() }
        case .bass:       fetchOrCreate(Bass.self)        { Bass() }
        case .banjo:      fetchOrCreate(Banjo.self)       { Banjo() }
        case .guitar:     fetchOrCreate(Guitar.self)      { Guitar() }
        case .modePicker: fetchOrCreate(ModePicker.self)  { ModePicker() }
        case .tonicPicker:fetchOrCreate(TonicPicker.self) { TonicPicker() }
        }
        
        instrument.synthConductor = Self.sharedSynthConductor
        
        return instrument
    }
    
    @MainActor
    private func fetchOrCreate<T: PersistentModel>(
        _ type: T.Type,
        create: () -> T
    ) -> T {
        if let existing = (try? fetch(FetchDescriptor<T>()))?.first {
            return existing
        }
        let newInst = create()
        insert(newInst)
        return newInst
    }
}
