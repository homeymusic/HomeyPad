//
//  swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/24/24.
//

import SwiftUI
import Keyboard
import Tonic

class ViewConductor: ObservableObject {
    
    @Published var lowNote = 24
    @Published var highNote = 48
    
    @Published var scaleIndex = Scale.allCases.firstIndex(of: .chromatic) ?? 0 {
        didSet {
            if scaleIndex >= Scale.allCases.count { scaleIndex = 0 }
            if scaleIndex < 0 { scaleIndex = Scale.allCases.count - 1 }
            scale = Scale.allCases[scaleIndex]
        }
    }
    
    @Published var scale: Scale = .chromatic
    @Published var root: NoteClass = .C
    @Published var rootIndex = 0
    @Published var tonicPitch: Pitch = Pitch(60)
    
    @Published var keyboardIndex: Int = 1
    
    let evenSpacingInitialSpacerRatio: [Letter: CGFloat] = [
        .C: 0.0,
        .D: 2.0 / 12.0,
        .E: 4.0 / 12.0,
        .F: 0.0 / 12.0,
        .G: 1.0 / 12.0,
        .A: 3.0 / 12.0,
        .B: 5.0 / 12.0
    ]
    
    let evenSpacingSpacerRatio: [Letter: CGFloat] = [
        .C: 7.0 / 12.0,
        .D: 7.0 / 12.0,
        .E: 7.0 / 12.0,
        .F: 7.0 / 12.0,
        .G: 7.0 / 12.0,
        .A: 7.0 / 12.0,
        .B: 7.0 / 12.0
    ]
    
    let evenSpacingRelativeBlackKeyWidth: CGFloat = 7.0 / 12.0
    
    var randomColors: [Color] = (0 ... 12).map { _ in
        Color(red: Double.random(in: 0 ... 1),
              green: Double.random(in: 0 ... 1),
              blue: Double.random(in: 0 ... 1), opacity: 1)
    }
    
    func noteOn(pitch: Pitch, point: CGPoint) {
        print("note on \(pitch)")
    }
    
    func noteOff(pitch: Pitch) {
        print("note off \(pitch)")
    }
    
    func noteOnWithVerticalVelocity(pitch: Pitch, point: CGPoint) {
        print("note on \(pitch), midiVelocity: \(Int(point.y * 127))")
    }
    
    func noteOnWithReversedVerticalVelocity(pitch: Pitch, point: CGPoint) {
        print("note on \(pitch), midiVelocity: \(Int((1.0 - point.y) * 127))")
    }
    
}

