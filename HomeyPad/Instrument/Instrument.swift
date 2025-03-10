import Foundation
import MIDIKitIO
import HomeyMusicKit

public class Instrument: ObservableObject {
    public let instrumentType: InstrumentType

    public init(instrumentType: InstrumentType) {
        self.instrumentType = instrumentType
    }
    
    // TODO: put all the notational settings in here?
    // current thinking? No. In fact, maybe it is better
    // if (like accidental choice) any chaoice about metadata
    // applies to all the instrumnts.
    // then create an InstrumentsDefaultsManager for it?
    // and move it all into HomeyMusicKit?
    // and accidental setting probably goes in here?
}
