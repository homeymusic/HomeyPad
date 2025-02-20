import SwiftUI
import HomeyMusicKit
import MIDIKitCore

// MARK: - PianoView

struct PianoView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor
    @StateObject private var tonalContext = TonalContext.shared
    let spacer: PianoSpacer
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                ForEach(rows, id: \.self) { row in
                    PianoRowView(
                        row: row,
                        geoSize: geo.size,
                        viewConductor: viewConductor,
                        tonalContext: tonalContext,
                        spacer: spacer,
                        keyboardKeyView: keyboardKeyView
                    )
                }
                .clipShape(Rectangle())
            }
        }
    }
    
    private var rows: [Int] {
        let minRow = -viewConductor.layoutRowsCols.rowsPerSide[.piano]!
        let maxRow = viewConductor.layoutRowsCols.rowsPerSide[.piano]!
        return Array(minRow...maxRow).reversed()
    }
}

// MARK: - PianoRowView

struct PianoRowView<Content>: View where Content: View {
    let row: Int
    let geoSize: CGSize
    let viewConductor: ViewConductor
    let tonalContext: TonalContext
    let spacer: PianoSpacer
    let keyboardKeyView: (Pitch) -> Content
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            PianoWhiteKeysRow(
                row: row,
                geoWidth: geoSize.width,
                viewConductor: viewConductor,
                spacer: spacer,
                keyboardKeyView: keyboardKeyView
            )
//            PianoBlackKeysOverlay(
//                row: row,
//                geoSize: geoSize,
//                viewConductor: viewConductor,
//                spacer: spacer,
//                keyboardKeyView: keyboardKeyView
//            )
        }
        .animation(viewConductor.animationStyle, value: tonalContext.tonicMIDI)
    }
}

// MARK: - PianoWhiteKeysRow

struct PianoWhiteKeysRow<Content>: View where Content: View {
    let row: Int
    let geoWidth: CGFloat
    let viewConductor: ViewConductor
    let spacer: PianoSpacer
    let keyboardKeyView: (Pitch) -> Content
    
    var body: some View {
        HStack(spacing: 0) {
            // Assume Pitch.naturalMIDI is a [MIDINote]
            ForEach(Pitch.naturalMIDI, id: \.self) { whiteNote in
                let noteValue = 12 * row + whiteNote.number.intValue
                Group {
                    if Pitch.isValidPitch(noteValue) {
                        let midi = MIDINoteNumber(noteValue)
                        KeyboardKeyContainerView(
                            conductor: viewConductor,
                            pitch: Pitch.pitch(for: midi),
                            keyboardKeyView: keyboardKeyView
                        )
                    } else {
                        Color.clear
                    }
                }
                .frame(width: spacer.whiteKeyWidth(geoWidth))
            }
        }
    }
}

// MARK: - PianoBlackKeysOverlay

//struct PianoBlackKeysOverlay<Content>: View where Content: View {
//    let row: Int
//    let geoSize: CGSize
//    let viewConductor: ViewConductor
//    let spacer: PianoSpacer
//    let keyboardKeyView: (Pitch) -> Content
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            HStack(spacing: 0) {
//                // Left spacer for black keys.
//                Rectangle()
//                    .opacity(0)
//                    .frame(width: spacer.initialSpacerWidth(geoSize.width))
//                
//                ForEach(spacer.midiBoundedByNaturals, id: \.self) { anyNote in
//                    let noteValue = 12 * row + anyNote.number.intValue
//                    Group {
//                        ZStack {
//                            if Pitch.isValidPitch(noteValue) {
//                                let midi = MIDINoteNumber(noteValue)
//                                if Pitch.accidental(note: midi) {
//                                    KeyboardKeyContainerView(
//                                        conductor: viewConductor,
//                                        pitch: Pitch.pitch(for: midi),
//                                        zIndex: 1,
//                                        keyboardKeyView: keyboardKeyView
//                                    )
//                                } else {
//                                    // For non-accidental keys, render a transparent spacer.
//                                    Rectangle()
//                                        .opacity(0)
//                                        .frame(width: spacer.blackKeySpacerWidth(geoSize.width,
//                                                                                 note: try! MIDINote(noteValue)))
//                                }
//                            } else {
//                                Color.clear
//                            }
//                        }
//                        .frame(width: spacer.blackKeyWidth(geoSize.width))
//                    }
//                }
//                Spacer()
//                    .frame(height: geoSize.height * (1 - spacer.relativeBlackKeyHeight))
//            }
//        }
//    }
//}

// MARK: - PianoSpacer

/// NOTE: Because PianoSpacer is a helper value type (not a View),
/// it’s best to pass in its dependencies as plain values rather than using property wrappers.
public struct PianoSpacer {
    let tonalContext: TonalContext
    @ObservedObject var viewConductor: ViewConductor
    
    public var initialSpacerRatio: [PitchClass: CGFloat] = PianoSpacer.defaultInitialSpacerRatio
    public var spacerRatio: [PitchClass: CGFloat] = PianoSpacer.defaultSpacerRatio
    public var relativeBlackKeyWidth: CGFloat = PianoSpacer.defaultRelativeBlackKeyWidth
    public var relativeBlackKeyHeight: CGFloat = PianoSpacer.defaultRelativeBlackKeyHeight
    
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
    public static let defaultRelativeBlackKeyHeight: CGFloat = 0.53
}

extension PianoSpacer {
    public var whiteNotes: [MIDINote] {
        // Filter the midiBoundedByNaturals array for natural (non-accidental) notes.
        midiBoundedByNaturals.filter { !Pitch.accidental(midiNote: $0) }
    }
    
    public func isBlackKey(_ note: MIDINote) -> Bool {
        Pitch.accidental(midiNote: note)
    }
    
    public var initialSpacer: CGFloat {
        // Use the minimum note from the bounded array to determine the pitch class.
        let pitchClass = PitchClass(noteNumber: Int(midiBoundedByNaturals.min()!.number))
        return initialSpacerRatio[pitchClass] ?? 0
    }
    
    public func space(note: MIDINote) -> CGFloat {
        let pitchClass = PitchClass(noteNumber: Int(note.number))
        return spacerRatio[pitchClass] ?? 0
    }
    
    public func whiteKeyWidth(_ width: CGFloat) -> CGFloat {
        width / CGFloat(whiteNotes.count)
    }
    
    public func blackKeyWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * relativeBlackKeyWidth
    }
    
    public var midiBoundedByNaturals: [MIDINote] {
        // Compute lower and upper bounds from tonalContext natural arrays.
        guard let lowerBound = tonalContext.naturalsBelowTritone.min(),
              let upperBound = tonalContext.naturalsAboveTritone.max() else {
            return []
        }
        
        return MIDINote.allNotes().filter { note in
            note >= lowerBound && note <= upperBound
        }
    }
    
    public func initialSpacerWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * initialSpacer
    }
    
    public func blackKeySpacerWidth(_ width: CGFloat, note: MIDINote) -> CGFloat {
        whiteKeyWidth(width) * space(note: note)
    }
}
