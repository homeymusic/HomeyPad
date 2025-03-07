import Foundation
import HomeyMusicKit
import MIDIKitIO

public class Cello: StringInstrument {
    
    public init() {
        super.init(instrumentType: .cello)
    }

    public override var openStringsMIDI: [Int] { [57, 50, 43, 36] }

}
