import Foundation
import HomeyMusicKit
import MIDIKitIO

public class Tonnetz: KeyboardInstrument {
    
    public init() {
        switch HomeyPad.formFactor {
        case .iPhone:
            super.init(instrumentType: .tonnetz,
                       defaultRows: 0, minRows: 0, maxRows: 5,
                       defaultCols: 8, minCols: 6, maxCols: 18)
        case .iPad:
            super.init(instrumentType: .tonnetz,
                       defaultRows: 0, minRows: 0, maxRows: 2,
                       defaultCols: 13, minCols: 6, maxCols: 18)
        }
    }
    
}
