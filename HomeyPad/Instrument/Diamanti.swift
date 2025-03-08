import Foundation
import HomeyMusicKit
import MIDIKitIO

public class Diamanti: KeyboardInstrument {
    public init() {
        switch HomeyPad.formFactor {
        case .iPhone:
            super.init(instrumentType: .diamanti,
                       defaultRows: 0, minRows: 0, maxRows: 2,
                       defaultCols: 13, minCols: 6, maxCols: 18)
        case .iPad:
            super.init(instrumentType: .diamanti,
                       defaultRows: 0, minRows: 0, maxRows: 2,
                       defaultCols: 18, minCols: 6, maxCols: 30)
        }
    }
    
    public override func fewerCols() {
        if fewerColsAreAvailable {
            let colJump: [Int:Int] = [
                29:2,
                27:2,
                25:3,
                22:2,
                20:2,
                17:2,
                15:2,
                13:3,
                10:2,
                8:2
            ]
            cols -= colJump[cols] ?? 1
        }
    }
    
    public override func moreCols() {
        if moreColsAreAvailable {
            let colJump: [Int:Int] = [
                6:2,
                8:2,
                10:3,
                13:2,
                15:2,
                18:2,
                20:2,
                22:3,
                25:2,
                27:2
            ]
            cols += colJump[cols] ?? 1
        }
    }

}
