import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct PianoView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor
    @StateObject private var tonalContext = TonalContext.shared
    
    let spacer: PianoSpacer
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                ForEach((-viewConductor.layoutRowsCols.rowsPerSide[.piano]!...viewConductor.layoutRowsCols.rowsPerSide[.piano]!).reversed(), id: \.self) { row in
                    ZStack(alignment: .topLeading) {
                        HStack(spacing: 0) {
                            ForEach(spacer.whiteNotes, id: \.self) { col in
                                let note: Int = col + 12 * row
                                if MIDIConductor.isValidMIDI(note: note) {
                                    let midi = MIDINoteNumber(note)
                                    KeyboardKeyContainerView(conductor: viewConductor,
                                                             pitch: Pitch.pitch(for: midi),                                  keyboardKeyView: keyboardKeyView)
                                    .frame(width: spacer.whiteKeyWidth(geo.size.width))
                                } else {
                                    Color.clear
                                        .frame(width: spacer.whiteKeyWidth(geo.size.width))
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 0) {
                                Rectangle().opacity(0)
                                    .frame(width: spacer.initialSpacerWidth(geo.size.width))
                                ForEach(spacer.midiBoundedByNaturals, id: \.self) { col in
                                    let note: Int = Int(col) + 12 * row
                                    if Pitch.accidental(note: note) {
                                        ZStack {
                                            if MIDIConductor.isValidMIDI(note: note) {
                                                let midi = MIDINoteNumber(note)
                                                KeyboardKeyContainerView(conductor: viewConductor,
                                                                         pitch: Pitch.pitch(for: midi),
                                                                         zIndex: 1,
                                                                         keyboardKeyView: keyboardKeyView)
                                            } else {
                                                Color.clear
                                            }
                                        }
                                        .frame(width: spacer.blackKeyWidth(geo.size.width))
                                    } else {
                                        Rectangle().opacity(0)
                                            .frame(width: spacer.blackKeySpacerWidth(geo.size.width, note: note))
                                    }
                                }
                            }
                            
                            Spacer().frame(height: geo.size.height * (1 - spacer.relativeBlackKeyHeight))
                        }
                    }
                    .animation(viewConductor.animationStyle, value: tonalContext.tonicMIDI)
                }
                .clipShape(Rectangle())
            }
        }
    }
}

public struct PianoSpacer {
    @StateObject private var tonalContext = TonalContext.shared
    
    public static let defaultInitialSpacerRatio: [PitchClass: CGFloat] = [
        .zero: 0.0,
        .two: 3.0 / 16.0,
        .four: 6.0 / 16.0,
        .five: 0.0 / 16.0,
        .seven: 3.0 / 16.0,
        .nine: 4.5 / 16.0,
        .eleven: 6.0 / 16.0
    ]
    public static let defaultSpacerRatio: [PitchClass: CGFloat] = [
        .zero: 10.0 / 16.0,
        .two: 10.0 / 16.0,
        .four: 10.0 / 16.0,
        .five: 10.0 / 16.0,
        .seven: 8.5 / 16.0,
        .nine: 8.5 / 16.0,
        .eleven: 10.0 / 16.0
    ]
    public static let defaultRelativeBlackKeyWidth: CGFloat = 9.0 / 16.0
    
    /// Default value for Black Key Height
    public static let defaultRelativeBlackKeyHeight: CGFloat = 0.53
    
    @ObservedObject var viewConductor: ViewConductor
    public var initialSpacerRatio: [PitchClass: CGFloat] = PianoSpacer.defaultInitialSpacerRatio
    public var spacerRatio: [PitchClass: CGFloat] = PianoSpacer.defaultSpacerRatio
    public var relativeBlackKeyWidth: CGFloat = PianoSpacer.defaultRelativeBlackKeyWidth
    public var relativeBlackKeyHeight: CGFloat = PianoSpacer.defaultRelativeBlackKeyHeight
}

extension PianoSpacer {
    public var whiteNotes: [Int] {
        var naturalNotes: [Int] = []
        for note in midiBoundedByNaturals where !Pitch.accidental(note: Int(note)) {
            naturalNotes.append(Int(note))
        }
        return naturalNotes
    }
    
    public func isBlackKey(_ note: Int) -> Bool {
        Pitch.accidental(note: note)
    }
    
    public var initialSpacer: CGFloat {
        let pitchClass = PitchClass(noteNumber: Int(midiBoundedByNaturals.first!))
        return initialSpacerRatio[pitchClass] ?? 0
    }
    
    public func space(note: Int) -> CGFloat {
        let pitchClass = PitchClass(noteNumber: note)
        return spacerRatio[pitchClass] ?? 0
    }
    
    public func whiteKeyWidth(_ width: CGFloat) -> CGFloat {
        width / CGFloat(whiteNotes.count)
    }
    
    public func blackKeyWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * relativeBlackKeyWidth
    }
    
    public var midiBoundedByNaturals: ClosedRange<Int> {
        var colsBelow = viewConductor.layoutRowsCols.colsPerSide[.piano]!
        var colsAbove = viewConductor.layoutRowsCols.colsPerSide[.piano]!
        
        // if F .five or B .eleven are the tonic then the tritone will be off center
        if tonalContext.tonicPitch.pitchClass == .five {
            colsBelow = colsBelow - 1
        } else if tonalContext.tonicPitch.pitchClass == .eleven {
            colsAbove = colsAbove - 1
        }
        
        let naturalsBelowTritone = Array(Pitch.naturalMIDI.filter({$0 < tonalContext.tritoneMIDI}).suffix(colsBelow))
        let naturalsAboveTritone = Array(Pitch.naturalMIDI.filter({$0 > tonalContext.tritoneMIDI}).prefix(colsAbove))
        
        let lowIndex: Int = Int(naturalsBelowTritone.min() ?? 0)
        let highIndex: Int = Int(naturalsAboveTritone.max() ?? 127)
        
        return lowIndex...highIndex
    }
    
    public func initialSpacerWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * initialSpacer
    }
    
    public func lowerBoundSpacerWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * space(note: viewConductor.layoutNotes.lowerBound)
    }
    
    public func blackKeySpacerWidth(_ width: CGFloat, note: Int) -> CGFloat {
        whiteKeyWidth(width) * space(note: note)
    }
}
