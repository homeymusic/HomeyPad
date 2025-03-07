import Foundation
import HomeyMusicKit
import MIDIKitIO

public class Bass: StringInstrument {
    
    public init() {
        super.init(instrumentType: .bass)
    }
    
    public override var openStringsMIDI: [Int] { [43, 38, 33, 28] }
}
