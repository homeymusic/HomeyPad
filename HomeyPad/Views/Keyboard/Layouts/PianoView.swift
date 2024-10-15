import SwiftUI
import HomeyMusicKit

struct PianoView<Content>: View where Content: View {
    let keyboardKeyView: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor
    let spacer: PianoSpacer

    var body: some View {
        VStack(spacing: 0) {
            let rows = (-viewConductor.layoutRowsCols.rowsPerSide[.piano]! ... viewConductor.layoutRowsCols.rowsPerSide[.piano]!).reversed()

            ForEach(rows, id: \.self) { row in
                GeometryReader { geo in
                    ZStack(alignment: .topLeading) {
                        // Calculate white keys for this row
                        let whiteKeys = spacer.whiteMIDI.map { Int($0) + 12 * row }

                        WhiteKeysView(
                            whiteKeys: whiteKeys,
                            geoWidth: geo.size.width,
                            keyboardKeyView: keyboardKeyView,
                            viewConductor: viewConductor,
                            spacer: spacer
                        )

                        BlackKeysView(
                            row: row,
                            geoWidth: geo.size.width,
                            keyboardKeyView: keyboardKeyView,
                            viewConductor: viewConductor,
                            spacer: spacer
                        )
                    }
                    .animation(viewConductor.animationStyle, value: TonalContext.shared.tonicPitch.midi)
                }
                .clipShape(Rectangle())
            }
        }
    }
}

struct WhiteKeysView<Content>: View where Content: View {
    let whiteKeys: [Int]
    let geoWidth: CGFloat
    let keyboardKeyView: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor
    let spacer: PianoSpacer

    var body: some View {
        HStack(spacing: 0) {
            ForEach(whiteKeys, id: \.self) { unSureMIDI in
                let keyWidth = spacer.whiteKeyWidth(geoWidth)
                if TonalContext.shared.safeMIDI(midi: unSureMIDI) {
                    KeyboardKeyContainerView(
                        conductor: viewConductor,
                        pitch: TonalContext.shared.pitch(for: Int8(unSureMIDI)),
                        keyboardKeyView: keyboardKeyView
                    )
                    .frame(width: keyWidth)
                } else {
                    Color.clear.frame(width: keyWidth)
                }
            }
        }
    }
}

struct BlackKeysView<Content>: View where Content: View {
    let row: Int
    let geoWidth: CGFloat
    let keyboardKeyView: (Pitch) -> Content
    @ObservedObject var viewConductor: ViewConductor
    let spacer: PianoSpacer

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Rectangle().opacity(0)
                    .frame(width: spacer.initialSpacerWidth(geoWidth))

                ForEach(spacer.midiBoundedByNaturals, id: \.self) { col in
                    let unSureMIDI = Int(col) + 12 * row
                    if Pitch.accidental(midi: Int8(unSureMIDI)) {
                        let blackKeyWidth = spacer.blackKeyWidth(geoWidth)
                        ZStack {
                            if TonalContext.shared.safeMIDI(midi: unSureMIDI) {
                                KeyboardKeyContainerView(
                                    conductor: viewConductor,
                                    pitch: TonalContext.shared.pitch(for: Int8(unSureMIDI)),
                                    zIndex: 1,
                                    keyboardKeyView: keyboardKeyView
                                )
                            } else {
                                Color.clear
                            }
                        }
                        .frame(width: blackKeyWidth)
                    } else {
                        let blackKeySpacer = spacer.blackKeySpacerWidth(geoWidth, midi: Int8(unSureMIDI))
                        Rectangle().opacity(0).frame(width: blackKeySpacer)
                    }
                }
            }
            Spacer().frame(height: geoWidth * (1 - spacer.relativeBlackKeyHeight))
        }
    }
}

public struct PianoSpacer {
    public static let defaultInitialSpacerRatio: [IntegerNotation: CGFloat] = [
        .zero: 0.0,
        .two: 3.0 / 16.0,
        .four: 6.0 / 16.0,
        .five: 0.0 / 16.0,
        .seven: 3.0 / 16.0,
        .nine: 4.5 / 16.0,
        .eleven: 6.0 / 16.0
    ]
    public static let defaultSpacerRatio: [IntegerNotation: CGFloat] = [
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
    public var initialSpacerRatio: [IntegerNotation: CGFloat] = PianoSpacer.defaultInitialSpacerRatio
    public var spacerRatio: [IntegerNotation: CGFloat] = PianoSpacer.defaultSpacerRatio
    public var relativeBlackKeyWidth: CGFloat = PianoSpacer.defaultRelativeBlackKeyWidth
    public var relativeBlackKeyHeight: CGFloat = PianoSpacer.defaultRelativeBlackKeyHeight
}

extension PianoSpacer {
    public var whiteMIDI: [Int8] {
        var naturalMIDI: [Int8] = []
        for midi in midiBoundedByNaturals where !Pitch.accidental(midi: midi) {
            naturalMIDI.append(midi)
        }
        return naturalMIDI
    }

    public func isBlackKey(_ midi: Int8) -> Bool {
        Pitch.accidental(midi: midi)
    }

    public var initialSpacer: CGFloat {
        let pitchClass = Pitch.pitchClass(midi: midiBoundedByNaturals.first!)
        return initialSpacerRatio[pitchClass] ?? 0
    }

    public func space(midi: Int8) -> CGFloat {
        let pitchClass = Pitch.pitchClass(midi: midi)
        return spacerRatio[pitchClass] ?? 0
    }

    public func whiteKeyWidth(_ width: CGFloat) -> CGFloat {
        width / CGFloat(whiteMIDI.count)
    }

    public func blackKeyWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * relativeBlackKeyWidth
    }

    public var midiBoundedByNaturals: ClosedRange<Int8> {
        var colsBelow = viewConductor.layoutRowsCols.colsPerSide[.piano]!
        var colsAbove = viewConductor.layoutRowsCols.colsPerSide[.piano]!
                
        // if F .five or B .eleven are the tonic then the tritone will be off center
        if TonalContext.shared.tonicPitch.pitchClass == .five {
            colsBelow = colsBelow - 1
        } else if TonalContext.shared.tonicPitch.pitchClass == .eleven {
            colsAbove = colsAbove - 1
        }
        
        let naturalsBelowTritone = TonalContext.shared.naturalsBelowTritone.suffix(colsBelow)
        let naturalsAboveTritone = TonalContext.shared.naturalsAboveTritone.prefix(colsAbove)

        let lowIndex: Int8 = naturalsBelowTritone.min() ?? 0
        let highIndex: Int8 = naturalsAboveTritone.max() ?? 127
        
        return lowIndex...highIndex
    }

    public func initialSpacerWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * initialSpacer
    }

    public func lowerBoundSpacerWidth(_ width: CGFloat) -> CGFloat {
        whiteKeyWidth(width) * space(midi: viewConductor.lowMIDI)
    }

    public func blackKeySpacerWidth(_ width: CGFloat, midi: Int8) -> CGFloat {
        whiteKeyWidth(width) * space(midi: midi)
    }
}
