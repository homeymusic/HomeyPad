import Foundation
import HomeyMusicKit
import MIDIKitIO

public class Violin: StringInstrument {
    
    public init() {
        super.init(instrumentType: .violin)
    }
    
    public override var openStringsMIDI: [Int] {[76, 69, 62, 55]}

}
