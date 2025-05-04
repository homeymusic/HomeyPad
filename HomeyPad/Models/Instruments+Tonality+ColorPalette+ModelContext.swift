import SwiftData
import Foundation
import HomeyMusicKit

public extension ModelContext {

    @MainActor
    func tonality() -> Tonality {
        fetchOrCreate(Tonality.self) { Tonality() }
    }
    
    @MainActor
    var tonalityInstrument: TonalityInstrument {
        fetchOrCreate(TonalityInstrument.self) { TonalityInstrument(tonality: tonality()) }
    }

    @MainActor
    func singletonInstrument(for type: MusicalInstrumentType) -> any MusicalInstrument {
        let instrument: any MusicalInstrument
        switch type {
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
        
        ensureColorPalette(on: instrument)
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
    
    @MainActor
    func ensureColorPalette(on instrument: any MusicalInstrument) {
        guard
            instrument.intervalColorPalette == nil,
            instrument.pitchColorPalette    == nil
        else { return }
        
        let descriptor = FetchDescriptor<IntervalColorPalette>(
            sortBy: [SortDescriptor(\.position)]
        )
        
        // Try to fetch any existing palettes
        var palettes = (try? fetch(descriptor)) ?? []
        
        // If none exist, seed the system defaults and re-fetch
        if palettes.isEmpty {
            IntervalColorPalette.seedSystemIntervalPalettes(modelContext: self)
            PitchColorPalette.seedSystemPitchPalettes(modelContext: self)
            palettes = (try? fetch(descriptor)) ?? []
        }
        
        // Assign the first available interval palette
        if let first = palettes.first {
            instrument.intervalColorPalette = first
        }
    }
}
