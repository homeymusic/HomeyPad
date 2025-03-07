import SwiftUI
import MIDIKitIO
import HomeyMusicKit

public class KeyboardInstrument: Instrument {
    // Layout configuration properties (immutable)
    public let defaultRows: Int
    public let minRows: Int
    public let maxRows: Int
    
    public let defaultCols: Int
    public let minCols: Int
    public let maxCols: Int
    
    // State properties to track current layout.
    @Published public var rows: Int
    @Published public var cols: Int
    
    public init(instrumentType: InstrumentType,
                defaultRows: Int,
                minRows: Int,
                maxRows: Int,
                defaultCols: Int,
                minCols: Int,
                maxCols: Int) {
        
        self.defaultRows = defaultRows
        self.minRows = minRows
        self.maxRows = maxRows
        
        self.defaultCols = defaultCols
        self.minCols = minCols
        self.maxCols = maxCols
        
        self.rows = defaultRows
        self.cols = defaultCols
        
        super.init(instrumentType: instrumentType)
    }
    
    // MARK: - Row Methods
    
    public func resetRows() {
        rows = defaultRows
    }
    
    public var fewerRowsAreAvailable: Bool {
        rows > minRows
    }
    
    public func fewerRows() {
        if fewerRowsAreAvailable {
            rows -= 1
        }
    }
    
    public var moreRowsAreAvailable: Bool {
        rows < maxRows
    }
    
    public func moreRows() {
        if moreRowsAreAvailable {
            rows += 1
        }
    }
    
    // MARK: - Column Methods
    
    public func resetCols() {
        cols = defaultCols
    }
    
    public var fewerColsAreAvailable: Bool {
        cols > minCols
    }
    
    public func fewerCols() {
        if fewerColsAreAvailable {
            cols -= 1
        }
    }
    
    public var moreColsAreAvailable: Bool {
        cols < maxCols
    }
    
    public func moreCols() {
        if moreColsAreAvailable {
            cols += 1
        }
    }
    
    // MARK: - Combined Reset
    
    public func resetRowsCols() {
        resetRows()
        resetCols()
    }
    
    public var rowColsAreNotDefault: Bool {
        cols != defaultCols || rows != defaultRows
    }
    
    public var rowIndices: [Int] {
        Array((-rows ... rows).reversed())
    }
    
    public func colIndices(forTonic tonic: Int, pitchDirection: PitchDirection) -> [Int] {
        let tritoneSemitones = (pitchDirection == .downward) ? -6 : 6
        let colsBelow = tonic + tritoneSemitones - cols
        let colsAbove = tonic + tritoneSemitones + cols
        return Array(colsBelow...colsAbove)
    }
}
