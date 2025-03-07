import Foundation
import MIDIKitIO
import HomeyMusicKit

public class Instrument: ObservableObject {
    public let instrumentType: InstrumentType

    public init(instrumentType: InstrumentType) {
        self.instrumentType = instrumentType
    }
}
