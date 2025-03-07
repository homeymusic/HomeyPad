import Foundation
import HomeyMusicKit
import MIDIKitIO

public class Banjo: StringInstrument {
    
    public init() {
        super.init(instrumentType: .banjo)
    }
    
    public override var openStringsMIDI: [Int] { [62, 59, 55, 50, 62] }
}
