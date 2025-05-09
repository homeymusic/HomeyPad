import SwiftData
import Foundation
import HomeyMusicKit

public extension ModelContext {

    @MainActor
    func tonality() -> Tonality {
        fetchOrCreate(Tonality.self) { Tonality() }
    }
    
    @MainActor
    func tonalityInstrument() -> TonalityInstrument {
        fetchOrCreate(TonalityInstrument.self) {
            TonalityInstrument(
                tonality: tonality(),
                showModePicker: false,
                showTonicPicker: false,
                isAutoModeAndTonicEnabled: false,
                showOutlines: true,
                showModeOutlines: false
            )
        }
    }

    @MainActor
    func singletonInstrument(for type: MusicalInstrumentType) -> any MusicalInstrument {
        let musicalInstrument: any MusicalInstrument
        switch type {
        case .linear:
            musicalInstrument = fetchOrCreate(Linear.self) { Linear(tonality: tonality()) }
        case .tonnetz:
            musicalInstrument = fetchOrCreate(Tonnetz.self) { Tonnetz(tonality: tonality()) }
        case .diamanti:
            musicalInstrument = fetchOrCreate(Diamanti.self) { Diamanti(tonality: tonality()) }
        case .piano:
            musicalInstrument = fetchOrCreate(Piano.self) { Piano(tonality: tonality()) }
        case .violin:
            musicalInstrument = fetchOrCreate(Violin.self) { Violin(tonality: tonality()) }
        case .cello:
            musicalInstrument = fetchOrCreate(Cello.self) { Cello(tonality: tonality()) }
        case .bass:
            musicalInstrument = fetchOrCreate(Bass.self) { Bass(tonality: tonality()) }
        case .banjo:
            musicalInstrument = fetchOrCreate(Banjo.self) { Banjo(tonality: tonality()) }
        case .guitar:
            musicalInstrument = fetchOrCreate(Guitar.self) { Guitar(tonality: tonality()) }
        }
        
        musicalInstrument.midiInChannelMode  = .selected
        musicalInstrument.midiOutChannelMode = .selected
        ensureColorPalette(on: musicalInstrument)
        return musicalInstrument
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
