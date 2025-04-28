import SwiftData
import HomeyMusicKit

public extension ModelContext {
    
    @MainActor
    func tonality() -> Tonality {
        fetchOrCreate(Tonality.self) { Tonality() }
    }

    @MainActor
    func instrument(for choice: InstrumentChoice) -> any Instrument {
        let instrument: any Instrument
        switch choice {
        case .linear:
            instrument = fetchOrCreate(Linear.self) { Linear(tonality: tonality()) }
        case .tonnetz:
            instrument = fetchOrCreate(Tonnetz.self) { Tonnetz(tonality: tonality()) }
        case .diamanti:
            instrument = fetchOrCreate(Diamanti.self) { Diamanti(tonality: tonality()) }
        case .piano:
            instrument = fetchOrCreate(Piano.self) { Piano(tonality: tonality()) }
        case .violin:
            instrument = fetchOrCreate(Violin.self) { Violin(tonality: tonality()) }
        case .cello:
            instrument = fetchOrCreate(Cello.self) { Cello(tonality: tonality()) }
        case .bass:
            instrument = fetchOrCreate(Bass.self) { Bass(tonality: tonality()) }
        case .banjo:
            instrument = fetchOrCreate(Banjo.self) { Banjo(tonality: tonality()) }
        case .guitar:
            instrument = fetchOrCreate(Guitar.self) { Guitar(tonality: tonality()) }
        case .modePicker:
            instrument = fetchOrCreate(ModePicker.self) { ModePicker(tonality: tonality()) }
        case .tonicPicker:
            instrument = fetchOrCreate(TonicPicker.self) { TonicPicker(tonality: tonality()) }
        }
        
        instrument.synthConductor = HomeyPad.synthConductor
        instrument.midiConductor  = HomeyPad.midiConductor
        
        return instrument
    }
    
    @MainActor
    private func fetchOrCreate<T: PersistentModel>(
        _ type: T.Type,
        create: () -> T
    ) -> T {
        // Try to fetch an existing instance
        if let fetched = (try? fetch(FetchDescriptor<T>()))?.first {
            return fetched
        }
        // Otherwise, create, insert, and return a new one
        let newObject = create()
        insert(newObject)
        return newObject
    }
}
