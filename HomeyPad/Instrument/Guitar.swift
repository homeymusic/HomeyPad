import Foundation
import HomeyMusicKit
import MIDIKitIO

public class Guitar: StringInstrument {
    
    public init() {
        super.init(instrumentType: .piano)
    }
    
    public override var openStringsMIDI: [Int] {[64, 59, 55, 50, 45, 40]}
}
