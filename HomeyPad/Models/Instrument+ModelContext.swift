// ModelContext+Instrument.swift

import SwiftData
import HomeyMusicKit

public extension ModelContext {
  /// Fetches or lazily creates the one-and-only instrument for this choice.
  @MainActor
  func instrument(for choice: InstrumentChoice) -> any Instrument {
    switch choice {
    case .linear:
      return fetchOrCreate(Linear.self)      { Linear() }
    case .tonnetz:
      return fetchOrCreate(Tonnetz.self)     { Tonnetz() }
    case .diamanti:
      return fetchOrCreate(Diamanti.self)    { Diamanti() }
    case .piano:
      return fetchOrCreate(Piano.self)       { Piano() }
    case .violin:
      return fetchOrCreate(Violin.self)      { Violin() }
    case .cello:
      return fetchOrCreate(Cello.self)       { Cello() }
    case .bass:
      return fetchOrCreate(Bass.self)        { Bass() }
    case .banjo:
      return fetchOrCreate(Banjo.self)       { Banjo() }
    case .guitar:
      return fetchOrCreate(Guitar.self)      { Guitar() }
    case .modePicker:
      return fetchOrCreate(ModePicker.self)  { ModePicker() }
    case .tonicPicker:
      return fetchOrCreate(TonicPicker.self) { TonicPicker() }
    }
  }

  /// Helper that fetches the first `T` or inserts a new one if none found.
  @MainActor
  private func fetchOrCreate<T: PersistentModel>(
    _ type: T.Type,
    create: () -> T
  ) -> T {
    // try fetch
    if let existing = (try? fetch(FetchDescriptor<T>()))?.first {
      return existing
    }
    // otherwise insert a new instance
    let newInst = create()
    insert(newInst)
    return newInst
  }
}
