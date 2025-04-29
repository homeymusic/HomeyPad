import SwiftData
import Foundation
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
            instrument = fetchOrCreate(Linear.self) { Linear(tonality: tonality(), pitches: HomeyPad.pitches) }
        case .tonnetz:
            instrument = fetchOrCreate(Tonnetz.self) { Tonnetz(tonality: tonality(), pitches: HomeyPad.pitches) }
        case .diamanti:
            instrument = fetchOrCreate(Diamanti.self) { Diamanti(tonality: tonality(), pitches: HomeyPad.pitches) }
        case .piano:
            instrument = fetchOrCreate(Piano.self) { Piano(tonality: tonality(), pitches: HomeyPad.pitches) }
        case .violin:
            instrument = fetchOrCreate(Violin.self) { Violin(tonality: tonality(), pitches: HomeyPad.pitches) }
        case .cello:
            instrument = fetchOrCreate(Cello.self) { Cello(tonality: tonality(), pitches: HomeyPad.pitches) }
        case .bass:
            instrument = fetchOrCreate(Bass.self) { Bass(tonality: tonality(), pitches: HomeyPad.pitches) }
        case .banjo:
            instrument = fetchOrCreate(Banjo.self) { Banjo(tonality: tonality(), pitches: HomeyPad.pitches) }
        case .guitar:
            instrument = fetchOrCreate(Guitar.self) { Guitar(tonality: tonality(), pitches: HomeyPad.pitches) }
        case .modePicker:
            instrument = fetchOrCreate(ModePicker.self) { ModePicker(tonality: tonality(), pitches: HomeyPad.pitches) }
        case .tonicPicker:
            instrument = fetchOrCreate(TonicPicker.self) { TonicPicker(tonality: tonality(), pitches: HomeyPad.pitches) }
        }
        
        instrument.synthConductor = HomeyPad.synthConductor
        instrument.midiConductor  = HomeyPad.midiConductor
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
    private func ensureColorPalette(on instrument: any Instrument) {
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
