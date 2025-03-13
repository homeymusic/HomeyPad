import SwiftUI
import MIDIKit
import HomeyMusicKit

class ViewConductor: ObservableObject {
    
    init(
        tonalContext: TonalContext
    ) {
        _tonalContext = StateObject(wrappedValue: tonalContext)
    }
    @StateObject var tonalContext: TonalContext

    var modeRectInfos: [ModeRectInfo] = []
    private var isModeLocked = false

    var modeLocations: [CGPoint] = [] {
        didSet {
            
            // Process the touch locations and determine which keys are touched
            for location in modeLocations {
                var mode: Mode?
                
                // Find the pitch at this location with the highest Z-index
                for info in modeRectInfos where info.rect.contains(location) {
                    if mode == nil {
                        mode = info.mode
                    }
                }
                
                if let m = mode {
                    
                    // Handle tonic mode
                    if !isModeLocked {
                        updateMode(m)
                        isModeLocked = true
                    }
                }
            }
            
            if modeLocations.isEmpty {
                isModeLocked = false
            }
        }
    }
        
    private func updateMode(_ newMode: Mode) {
        if newMode != tonalContext.mode {
            // Adjust pitch direction if the new tonic is an octave shift
            tonalContext.mode = newMode
        }
    }
    
}
