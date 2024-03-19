import AVFoundation
import Tonic
import MIDIKit
import Foundation
import SwiftUI

class ViewConductor: ObservableObject {
    // Audio Engine
    var conductor = Conductor()
    let defaults = UserDefaults.standard
    var notesPlaying = Set<UInt8>()
    
    // MIDI Manager (MIDI methods are in AVAudioUnitSampler+MIDI)
    let midiManager = ObservableMIDIManager(
        clientName: "Homey Pad",
        model: "iOS",
        manufacturer: "Homey Music"
    )
    
    @ObservedObject var midiHelper = MIDIHelper()
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
        
    @Published var linearLayout: Bool {
        didSet {
            defaults.set(self.linearLayout, forKey: "linearLayout")
            if oldValue != self.linearLayout {self.simpleSuccess()}
        }
    }
    @Published var linearLayoutOctaveCount: Int {
        didSet {
            defaults.set(self.linearLayoutOctaveCount, forKey: "linearLayoutOctaveCount")
            if oldValue != self.linearLayoutOctaveCount {self.simpleSuccess()}
        }
    }
    @Published var gridLayoutOctaveCount: Int {
        didSet {
            defaults.set(self.gridLayoutOctaveCount, forKey: "gridLayoutOctaveCount")
            if oldValue != self.gridLayoutOctaveCount {self.simpleSuccess()}
        }
    }
    @Published var linearLayoutKeysPerRow: Int {
        didSet {
            defaults.set(self.linearLayoutKeysPerRow, forKey: "linearLayoutKeysPerRow")
            if oldValue != self.linearLayoutKeysPerRow {self.simpleSuccess()}
        }
    }
    @Published var gridLayoutKeysPerRow: Int {
        didSet {
            defaults.set(self.gridLayoutKeysPerRow, forKey: "gridLayoutKeysPerRow")
            if oldValue != self.gridLayoutKeysPerRow {self.simpleSuccess()}
        }
    }
    @Published var showSelector: Bool {
        didSet {
            defaults.set(self.showSelector, forKey: "showSelector")
            if oldValue != self.showSelector {self.simpleSuccess()}
        }
    }
    @Published var showClassicalSelector: Bool {
        didSet {
            defaults.set(self.showClassicalSelector, forKey: "showClassicalSelector")
            if oldValue != self.showClassicalSelector {self.simpleSuccess()}
        }
    }
    @Published var showIntegersSelector: Bool {
        didSet {
            defaults.set(self.showIntegersSelector, forKey: "showIntegersSelector")
            if oldValue != self.showIntegersSelector {self.simpleSuccess()}
        }
    }
    @Published var showRomanSelector: Bool {
        didSet {
            defaults.set(self.showRomanSelector, forKey: "showRomanSelector")
            if oldValue != self.showRomanSelector {self.simpleSuccess()}
        }
    }
    @Published var showDegreeSelector: Bool {
        didSet {
            defaults.set(self.showDegreeSelector, forKey: "showDegreeSelector")
            if oldValue != self.showDegreeSelector {self.simpleSuccess()}
        }
    }
    @Published var showMonthsSelector: Bool {
        didSet {
            defaults.set(self.showMonthsSelector, forKey: "showMonthsSelector")
            if oldValue != self.showMonthsSelector {self.simpleSuccess()}
        }
    }
    @Published var showPianoSelector: Bool {
        didSet {
            defaults.set(self.showPianoSelector, forKey: "showPianoSelector")
            if oldValue != self.showPianoSelector {self.simpleSuccess()}
        }
    }
    @Published var showIntervals: Bool {
        didSet {
            defaults.set(self.showIntervals, forKey: "showIntervals")
            if oldValue != self.showIntervals {self.simpleSuccess()}
        }
    }
    @Published var tonicPitchClass: Int {
        didSet {
            defaults.set(self.tonicPitchClass, forKey: "tonicPitchClass")
            if oldValue != self.tonicPitchClass {
                midiHelper.sendTonic(noteNumber: UInt7(tonicNote()))
                self.simpleSuccess()
            }
        }
    }
    @Published var octaveShift: Int {
        didSet {
            defaults.set(self.octaveShift, forKey: "octaveShift")
            if oldValue != self.octaveShift {
                midiHelper.sendTonic(noteNumber: UInt7(tonicNote()))
                self.simpleSuccess()
            }
        }
    }
    @Published var upwardPitchMovement: Bool {
        didSet {
            defaults.set(self.upwardPitchMovement, forKey: "upwardPitchMovement")
            if oldValue != self.upwardPitchMovement {self.simpleSuccess()}
        }
    }
    @Published var nowPlayingTitle: any View = Text("")
    @Published var nowPlayingID: Int = 0
    @Published var scrollToID: Int = 0
    
    init() {
        defaults.register(defaults: ["linearLayout": Default.linearLayout, "octaveShift": Default.octaveShift, "linearLayoutOctaveCount": Default.linearLayoutOctaveCount, "gridLayoutOctaveCount": Default.gridLayoutOctaveCount, "linearLayoutKeysPerRow": Default.linearLayoutKeysPerRow, "gridLayoutKeysPerRow": Default.gridLayoutKeysPerRow, "showClassicalSelector": Default.showClassicalSelector, "showIntegersSelector": Default.showIntegersSelector, "showRomanSelector": Default.showRomanSelector, "showDegreeSelector": Default.showDegreeSelector, "showMonthsSelector": Default.showMonthsSelector, "showPianoSelector": Default.showPianoSelector, "showIntervals": Default.showIntervals, "tonicPitchClass": Default.tonicPitchClass,
                                     "upwardPitchMovement": Default.upwardPitchMovement])
        linearLayout = defaults.bool(forKey: "linearLayout")
        octaveShift = defaults.integer(forKey: "octaveShift")
        linearLayoutOctaveCount = defaults.integer(forKey: "linearLayoutOctaveCount")
        gridLayoutOctaveCount = defaults.integer(forKey: "gridLayoutOctaveCount")
        linearLayoutKeysPerRow = defaults.integer(forKey: "linearLayoutKeysPerRow")
        gridLayoutKeysPerRow = defaults.integer(forKey: "gridLayoutKeysPerRow")
        showSelector = defaults.bool(forKey: "showSelector")
        showClassicalSelector = defaults.bool(forKey: "showClassicalSelector")
        showIntegersSelector = defaults.bool(forKey: "showIntegersSelector")
        showRomanSelector = defaults.bool(forKey: "showRomanSelector")
        showDegreeSelector = defaults.bool(forKey: "showDegreeSelector")
        showMonthsSelector = defaults.bool(forKey: "showMonthsSelector")
        showPianoSelector = defaults.bool(forKey: "showPianoSelector")
        showIntervals  = defaults.bool(forKey: "showIntervals")
        tonicPitchClass = defaults.integer(forKey: "tonicPitchClass")
        upwardPitchMovement = defaults.bool(forKey: "upwardPitchMovement")
        midiHelper.setup(midiManager: midiManager)
        
        // Start the engine
        conductor.start()
        
    }
    
    func colsPerRow() -> Int {
        if (self.linearLayout) {
            return self.linearLayoutKeysPerRow
        } else {
            switch self.gridLayoutKeysPerRow {
            case 61:
                return 39
            case 59:
                return 37
            case 55:
                return 35
            case 51:
                return 33
            case 45:
                return 29
            case 41:
                return 27
            case 37: // keys per row
                return 22 // columns per row
            case 35:
                return 20
            case 31:
                return 18
            case 27:
                return 16
            case 21:
                return 12
            case 17:
                return 10
            case 13:
                return 8
            default:
                return 1
            }
        }
    }
    
    func octaveCount() -> Int {
        return self.linearLayout ? self.linearLayoutOctaveCount : self.gridLayoutOctaveCount
    }
    
    func playNote(_ midiNote: UInt8) {
        conductor.instrument.play(noteNumber: midiNote, velocity: 63, channel: 0)
        NotificationCenter.default.post(name: .MIDIKey, object: nil, userInfo: ["info": midiNote, "bool": true])
        notesPlaying.insert(midiNote)
        midiHelper.sendNoteOn(noteNumber: UInt7(midiNote))
    }
    
    func stopNote(_ midiNote: UInt8){
        conductor.instrument.stop(noteNumber: midiNote, channel: 0)
        NotificationCenter.default.post(name: .MIDIKey, object: nil, userInfo: ["info": midiNote, "bool": false])
        notesPlaying.remove(midiNote)
        midiHelper.sendNoteOff(noteNumber: UInt7(midiNote))
    }
    
    //Keyboard Events
    func noteOn(pitch: Pitch, point: CGPoint) {
        print("note on")
        conductor.instrument.play(noteNumber: UInt8(pitch.intValue), velocity: 63, channel: 0)
        midiHelper.sendNoteOn(noteNumber: UInt7(pitch.intValue))
    }
    
    func noteOff(pitch: Pitch) {
        print("note off")
        conductor.instrument.stop(noteNumber: UInt8(pitch.intValue), channel: 0)
        midiHelper.sendNoteOff(noteNumber: UInt7(pitch.intValue))
    }
    
    func resetNotes() {
        for midiNote in notesPlaying {
            stopNote(midiNote)
        }
    }
    func isPressable(col: Int) -> Bool {
        if col == 0 && self.upwardPitchMovement {
            return false
        } else if col == 12 && !self.upwardPitchMovement {
            return false
        } else {
            return true
        }
        
    }
    
    func selectHome(_ pitchClass: Int, _ col: Int, _ midiPlayer: MIDIPlayer) {
        let newPitchClass = pitchClass + mod(col, 12)
        if (newPitchClass != self.tonicPitchClass) {
            if (midiPlayer.state == .playing) {
                midiPlayer.pause()
                self.resetNotes()
                self.tonicPitchClass = newPitchClass
                midiPlayer.play()
            } else {
                self.tonicPitchClass = newPitchClass
            }
        }
        if col == 0 {
            self.upwardPitchMovement = true
        } else if col == 12 {
            self.upwardPitchMovement = false
        }
    }
    
    func updateMIDIFilter(Param: AUValue, knobNumber: Int){
    }
    
    func pitchMovementShowing() -> Bool {
        return showIntervals || showIntegersSelector || showRomanSelector || showDegreeSelector
    }
    
    func setPitchMovement(_ upward: Bool) {
        if showSelector && pitchMovementShowing() {
            upwardPitchMovement = upward
        }
    }
    func tonicNote() -> Int {
        return self.tonicPitchClass + self.octaveShift * 12 + Default.initialC
    }


}

extension NSNotification.Name {
    static let keyNoteOn = Notification.Name("keyNoteOn")
    static let keyNoteOff = Notification.Name("keyNoteOff")
    static let MIDIKey = Notification.Name("MIDIKey")
}
