import SwiftUI
import MIDIKitIO
import HomeyMusicKit

// Protocol enforcing `openStringsMIDI`
public protocol StringInstrumentProtocol {
    var openStringsMIDI: [Int] { get }
}

// StringInstrument class conforms to protocol
public class StringInstrument: Instrument, StringInstrumentProtocol {
    public var openStringsMIDI: [Int] {
        fatalError("Subclasses must implement openStringsMIDI")
    }
}
