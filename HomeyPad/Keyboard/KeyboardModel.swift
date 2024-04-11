// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI

public class KeyboardModel: ObservableObject {
    var keyRectInfos: [KeyRectInfo] = []
    var normalizedPoints = Array(repeating: CGPoint.zero, count: 128)
    
    var touchLocations: [CGPoint] = [] {
        didSet {
            var newPitches = Set<Pitch>()
            for location in touchLocations {
                var pitch: Pitch?
                var highestZindex = -1
                var normalizedPoint = CGPoint.zero
                for info in keyRectInfos where info.rect.contains(location) {
                    if pitch == nil || info.zIndex > highestZindex {
                        pitch = info.pitch
                        highestZindex = info.zIndex
                        normalizedPoint = CGPoint(x: (location.x - info.rect.minX) / info.rect.width,
                                                  y: (location.y - info.rect.minY) / info.rect.height)
                    }
                }
                if let p = pitch {
                    newPitches.insert(p)
                    normalizedPoints[p.intValue] = normalizedPoint
                }
            }
            if touchedPitches != newPitches {
                touchedPitches = newPitches
            }
        }
    }
    
    /// all touched notes
    @Published public var touchedPitches = Set<Pitch>() {
        willSet { triggerEvents(from: touchedPitches, to: newValue) }
    }
    
    /// Either latched keys or keys active due to external MIDI events.
    @Published public var externallyActivatedPitches = Set<Pitch>() {
        willSet { triggerEvents(from: externallyActivatedPitches, to: newValue) }
    }
    
    func triggerEvents(from oldValue: Set<Pitch>, to newValue: Set<Pitch>) {
        let newPitches = newValue.subtracting(oldValue)
        let oldPitches = oldValue.subtracting(newValue)
        
        for pitch in newPitches {
            pitch.noteOn()
        }
        
        for pitch in oldPitches {
            pitch.noteOff()
        }
    }
}
