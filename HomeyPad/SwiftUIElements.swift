import Foundation
import SwiftUI
import Keyboard
import Tonic
import Controls
import AVFoundation

struct SwiftUIHomeSelector: View {
    var viewConductor: ViewConductor
    var linearLayout: Bool
    var linearLayoutKeysPerRow: Int
    var gridLayoutKeysPerRow: Int
    var tonicPitchClass: Int
    var showClassicalSelector: Bool
    var showIntegersSelector: Bool
    var showRomanSelector: Bool
    var showDegreeSelector: Bool
    var showMonthsSelector: Bool
    var showPianoSelector: Bool
    var showIntervals: Bool
    var midiPlayer: MIDIPlayer
    var upwardPitchMovement: Bool
    
    var body: some View {
        if (linearLayout) {
            GeometryReader { proxy in
                HStack(spacing: 0) {
                    ForEach(0...12, id: \.self) { col in
                        if !viewConductor.isPressable(col: col) {
                            HStack(spacing: 0) {
                                SelectorStyle(col: col,
                                              viewConductor: viewConductor,
                                              showClassicalSelector: showClassicalSelector,
                                              showIntegersSelector: showIntegersSelector,
                                              showRomanSelector: showRomanSelector,
                                              showDegreeSelector: showDegreeSelector,
                                              showMonthsSelector: showMonthsSelector,
                                              showPianoSelector: showPianoSelector,
                                              showIntervals: showIntervals,
                                              tonicPitchClass: tonicPitchClass,
                                              upwardPitchMovement: upwardPitchMovement,
                                              linearLayout: linearLayout)
                            }
                            .frame(width: proxy.size.width * 1.0 / CGFloat(viewConductor.colsPerRow()))
                        } else {
                            HStack(spacing: 0) {
                                Button {
                                    viewConductor.selectHome(tonicPitchClass, col, midiPlayer)
                                } label: {
                                    SelectorStyle(col: col,
                                                  viewConductor: viewConductor,
                                                  showClassicalSelector: showClassicalSelector,
                                                  showIntegersSelector: showIntegersSelector,
                                                  showRomanSelector: showRomanSelector,
                                                  showDegreeSelector: showDegreeSelector,
                                                  showMonthsSelector: showMonthsSelector,
                                                  showPianoSelector: showPianoSelector,
                                                  showIntervals: showIntervals,
                                                  tonicPitchClass: tonicPitchClass,
                                                  upwardPitchMovement: upwardPitchMovement,
                                                  linearLayout: linearLayout)
                                }
                            }
                            .frame(width: proxy.size.width * 1.0 / CGFloat(viewConductor.colsPerRow()))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        } else {
            GeometryReader { proxy in
                Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                    GridRow {
                        HStack(spacing: 0) {
                            if !viewConductor.isPressable(col: 0) {
                                SelectorStyle(col: 0,
                                              viewConductor: viewConductor,
                                              showClassicalSelector: showClassicalSelector,
                                              showIntegersSelector: showIntegersSelector,
                                              showRomanSelector: showRomanSelector,
                                              showDegreeSelector: showDegreeSelector,
                                              showMonthsSelector: showMonthsSelector,
                                              showPianoSelector: showPianoSelector,
                                              showIntervals: showIntervals,
                                              tonicPitchClass: tonicPitchClass,
                                              upwardPitchMovement: upwardPitchMovement,
                                              linearLayout: linearLayout)
                            } else {
                                Button {
                                    viewConductor.selectHome(tonicPitchClass, 0, midiPlayer)
                                } label: {
                                    SelectorStyle(col: 0,
                                                  viewConductor: viewConductor,
                                                  showClassicalSelector: showClassicalSelector,
                                                  showIntegersSelector: showIntegersSelector,
                                                  showRomanSelector: showRomanSelector,
                                                  showDegreeSelector: showDegreeSelector,
                                                  showMonthsSelector: showMonthsSelector,
                                                  showPianoSelector: showPianoSelector,
                                                  showIntervals: showIntervals,
                                                  tonicPitchClass: tonicPitchClass,
                                                  upwardPitchMovement: upwardPitchMovement,
                                                  linearLayout: linearLayout)
                                }
                            }
                        }
                        .frame(width: proxy.size.width * 1.0 / CGFloat(viewConductor.colsPerRow()))
                        VStack(spacing: 0) {
                            Button {
                                viewConductor.selectHome(tonicPitchClass, 2, midiPlayer)
                            } label: {
                                SelectorStyle(col: 2,
                                              viewConductor: viewConductor,
                                              showClassicalSelector: showClassicalSelector,
                                              showIntegersSelector: showIntegersSelector,
                                              showRomanSelector: showRomanSelector,
                                              showDegreeSelector: showDegreeSelector,
                                              showMonthsSelector: showMonthsSelector,
                                              showPianoSelector: showPianoSelector,
                                              showIntervals: showIntervals,
                                              tonicPitchClass: tonicPitchClass,
                                              upwardPitchMovement: upwardPitchMovement,
                                              linearLayout: linearLayout)
                            }
                            Button {
                                viewConductor.selectHome(tonicPitchClass, 1, midiPlayer)
                            } label: {
                                SelectorStyle(col: 1,
                                              viewConductor: viewConductor,
                                              showClassicalSelector: showClassicalSelector,
                                              showIntegersSelector: showIntegersSelector,
                                              showRomanSelector: showRomanSelector,
                                              showDegreeSelector: showDegreeSelector,
                                              showMonthsSelector: showMonthsSelector,
                                              showPianoSelector: showPianoSelector,
                                              showIntervals: showIntervals,
                                              tonicPitchClass: tonicPitchClass,
                                              upwardPitchMovement: upwardPitchMovement,
                                              linearLayout: linearLayout)
                            }
                        }
                        .frame(width: proxy.size.width * 1.0 / CGFloat(viewConductor.colsPerRow()))
                        VStack(spacing: 0) {
                            Button {
                                viewConductor.selectHome(tonicPitchClass, 4, midiPlayer)
                            } label: {
                                SelectorStyle(col: 4,
                                              viewConductor: viewConductor,
                                              showClassicalSelector: showClassicalSelector,
                                              showIntegersSelector: showIntegersSelector,
                                              showRomanSelector: showRomanSelector,
                                              showDegreeSelector: showDegreeSelector,
                                              showMonthsSelector: showMonthsSelector,
                                              showPianoSelector: showPianoSelector,
                                              showIntervals: showIntervals,
                                              tonicPitchClass: tonicPitchClass,
                                              upwardPitchMovement: upwardPitchMovement,
                                              linearLayout: linearLayout)
                            }
                            Button {
                                viewConductor.selectHome(tonicPitchClass, 3, midiPlayer)
                            } label: {
                                SelectorStyle(col: 3,
                                              viewConductor: viewConductor,
                                              showClassicalSelector: showClassicalSelector,
                                              showIntegersSelector: showIntegersSelector,
                                              showRomanSelector: showRomanSelector,
                                              showDegreeSelector: showDegreeSelector,
                                              showMonthsSelector: showMonthsSelector,
                                              showPianoSelector: showPianoSelector,
                                              showIntervals: showIntervals,
                                              tonicPitchClass: tonicPitchClass,
                                              upwardPitchMovement: upwardPitchMovement,
                                              linearLayout: linearLayout)
                            }
                        }
                        .frame(width: proxy.size.width * 1.0 / CGFloat(viewConductor.colsPerRow()))
                        HStack(spacing: 0) {
                            Button {
                                viewConductor.selectHome(tonicPitchClass, 5, midiPlayer)
                            } label: {
                                SelectorStyle(col: 5,
                                              viewConductor: viewConductor,
                                              showClassicalSelector: showClassicalSelector,
                                              showIntegersSelector: showIntegersSelector,
                                              showRomanSelector: showRomanSelector,
                                              showDegreeSelector: showDegreeSelector,
                                              showMonthsSelector: showMonthsSelector,
                                              showPianoSelector: showPianoSelector,
                                              showIntervals: showIntervals,
                                              tonicPitchClass: tonicPitchClass,
                                              upwardPitchMovement: upwardPitchMovement,
                                              linearLayout: linearLayout)
                            }
                            Button {
                                viewConductor.selectHome(tonicPitchClass, 6, midiPlayer)
                            } label: {
                                SelectorStyle(col: 6,
                                              viewConductor: viewConductor,
                                              showClassicalSelector: showClassicalSelector,
                                              showIntegersSelector: showIntegersSelector,
                                              showRomanSelector: showRomanSelector,
                                              showDegreeSelector: showDegreeSelector,
                                              showMonthsSelector: showMonthsSelector,
                                              showPianoSelector: showPianoSelector,
                                              showIntervals: showIntervals,
                                              tonicPitchClass: tonicPitchClass,
                                              upwardPitchMovement: upwardPitchMovement,
                                              linearLayout: linearLayout)
                            }
                            Button {
                                viewConductor.selectHome(tonicPitchClass, 7, midiPlayer)
                            } label: {
                                SelectorStyle(col: 7,
                                              viewConductor: viewConductor,
                                              showClassicalSelector: showClassicalSelector,
                                              showIntegersSelector: showIntegersSelector,
                                              showRomanSelector: showRomanSelector,
                                              showDegreeSelector: showDegreeSelector,
                                              showMonthsSelector: showMonthsSelector,
                                              showPianoSelector: showPianoSelector,
                                              showIntervals: showIntervals,
                                              tonicPitchClass: tonicPitchClass,
                                              upwardPitchMovement: upwardPitchMovement,
                                              linearLayout: linearLayout)
                            }
                        }
                        .gridCellColumns(2)
                        .frame(width: proxy.size.width * 2.0 / CGFloat(viewConductor.colsPerRow()))
                        VStack(spacing: 0) {
                            Button {
                                viewConductor.selectHome(tonicPitchClass, 9, midiPlayer)
                            } label: {
                                SelectorStyle(col: 9,
                                              viewConductor: viewConductor,
                                              showClassicalSelector: showClassicalSelector,
                                              showIntegersSelector: showIntegersSelector,
                                              showRomanSelector: showRomanSelector,
                                              showDegreeSelector: showDegreeSelector,
                                              showMonthsSelector: showMonthsSelector,
                                              showPianoSelector: showPianoSelector,
                                              showIntervals: showIntervals,
                                              tonicPitchClass: tonicPitchClass,
                                              upwardPitchMovement: upwardPitchMovement,
                                              linearLayout: linearLayout)
                            }
                            Button {
                                viewConductor.selectHome(tonicPitchClass, 8, midiPlayer)
                            } label: {
                                SelectorStyle(col: 8,
                                              viewConductor: viewConductor,
                                              showClassicalSelector: showClassicalSelector,
                                              showIntegersSelector: showIntegersSelector,
                                              showRomanSelector: showRomanSelector,
                                              showDegreeSelector: showDegreeSelector,
                                              showMonthsSelector: showMonthsSelector,
                                              showPianoSelector: showPianoSelector,
                                              showIntervals: showIntervals,
                                              tonicPitchClass: tonicPitchClass,
                                              upwardPitchMovement: upwardPitchMovement,
                                              linearLayout: linearLayout)
                            }
                        }
                        .frame(width: proxy.size.width * 1.0 / CGFloat(viewConductor.colsPerRow()))
                        VStack(spacing: 0) {
                            Button {
                                viewConductor.selectHome(tonicPitchClass, 11, midiPlayer)
                            } label: {
                                SelectorStyle(col: 11,
                                              viewConductor: viewConductor,
                                              showClassicalSelector: showClassicalSelector,
                                              showIntegersSelector: showIntegersSelector,
                                              showRomanSelector: showRomanSelector,
                                              showDegreeSelector: showDegreeSelector,
                                              showMonthsSelector: showMonthsSelector,
                                              showPianoSelector: showPianoSelector,
                                              showIntervals: showIntervals,
                                              tonicPitchClass: tonicPitchClass,
                                              upwardPitchMovement: upwardPitchMovement,
                                              linearLayout: linearLayout)
                            }
                            Button {
                                viewConductor.selectHome(tonicPitchClass, 10, midiPlayer)
                            } label: {
                                SelectorStyle(col: 10,
                                              viewConductor: viewConductor,
                                              showClassicalSelector: showClassicalSelector,
                                              showIntegersSelector: showIntegersSelector,
                                              showRomanSelector: showRomanSelector,
                                              showDegreeSelector: showDegreeSelector,
                                              showMonthsSelector: showMonthsSelector,
                                              showPianoSelector: showPianoSelector,
                                              showIntervals: showIntervals,
                                              tonicPitchClass: tonicPitchClass,
                                              upwardPitchMovement: upwardPitchMovement,
                                              linearLayout: linearLayout)
                            }
                        }
                        .frame(width: proxy.size.width * 1.0 / CGFloat(viewConductor.colsPerRow()))
                        if !viewConductor.isPressable(col: 12) {
                            HStack(spacing: 0) {
                                SelectorStyle(col: 12,
                                              viewConductor: viewConductor,
                                              showClassicalSelector: showClassicalSelector,
                                              showIntegersSelector: showIntegersSelector,
                                              showRomanSelector: showRomanSelector,
                                              showDegreeSelector: showDegreeSelector,
                                              showMonthsSelector: showMonthsSelector,
                                              showPianoSelector: showPianoSelector,
                                              showIntervals: showIntervals,
                                              tonicPitchClass: tonicPitchClass,
                                              upwardPitchMovement: upwardPitchMovement,
                                              linearLayout: linearLayout)
                            }
                            .frame(width: proxy.size.width * 1.0 / CGFloat(viewConductor.colsPerRow()))
                        } else {
                            Button {
                                viewConductor.selectHome(tonicPitchClass, 12, midiPlayer)
                            } label: {
                                HStack(spacing: 0) {
                                    SelectorStyle(col: 12,
                                                  viewConductor: viewConductor,
                                                  showClassicalSelector: showClassicalSelector,
                                                  showIntegersSelector: showIntegersSelector,
                                                  showRomanSelector: showRomanSelector,
                                                  showDegreeSelector: showDegreeSelector,
                                                  showMonthsSelector: showMonthsSelector,
                                                  showPianoSelector: showPianoSelector,
                                                  showIntervals: showIntervals,
                                                  tonicPitchClass: tonicPitchClass,
                                                  upwardPitchMovement: upwardPitchMovement,
                                                  linearLayout: linearLayout)
                                }
                                .frame(width: proxy.size.width * 1.0 / CGFloat(viewConductor.colsPerRow()))
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct SwiftUIKeyboard: View {
    var linearLayout: Bool
    var octaveShift: Int
    var linearLayoutOctaveCount: Int
    var linearLayoutKeysPerRow: Int
    var gridLayoutOctaveCount: Int
    var gridLayoutKeysPerRow: Int
    var tonicPitchClass: Int
    var noteOn: (Pitch, CGPoint) -> Void = { _, _ in }
    var noteOff: (Pitch)->Void
    let initialC: Int = Default.initialC
    
    var body: some View {
        if (linearLayout) {
            Keyboard(layout: .dualistic(octaveShift: octaveShift, octaveCount: linearLayoutOctaveCount, keysPerRow: linearLayoutKeysPerRow, tonicPitchClass: tonicPitchClass, initialC: initialC),
                     noteOn: noteOn, noteOff: noteOff){ keyboardCell, pitch, isActivated in
                SwiftUIKeyboardKey(keyboardCell: keyboardCell,
                                   pitch: pitch,
                                   isActivated: isActivated,
                                   labelType: .symbol,
                                   tonicPitchClass: tonicPitchClass,
                                   initialC: initialC,
                                   homeColor: Default.perfectColor,
                                   homeColorDark: Default.homeColor,
                                   perfectColor:  Default.homeColor,
                                   perfectColorDark: Default.perfectColor,
                                   majorColor: Default.homeColor,
                                   majorColorDark: Default.majorColor,
                                   minorColor: Default.homeColor,
                                   minorColorDark: Default.minorColor,
                                   tritoneColor: Default.homeColor,
                                   tritoneColorDark: Default.tritoneColor,
                                   mostKeysAreLight: false,
                                   homeKeyIsLight: true,
                                   linearLayout: linearLayout
                )
            }.cornerRadius(5)
        } else {
            Keyboard(layout: .grid(octaveShift: octaveShift, octaveCount: gridLayoutOctaveCount, keysPerRow: gridLayoutKeysPerRow, tonicPitchClass: tonicPitchClass, initialC: initialC),
                     noteOn: noteOn, noteOff: noteOff){ keyboardCell, pitch, isActivated in
                SwiftUIKeyboardKey(keyboardCell: keyboardCell,
                                   pitch: pitch,
                                   isActivated: isActivated,
                                   labelType: .symbol,
                                   tonicPitchClass: tonicPitchClass,
                                   initialC: initialC,
                                   homeColor: Default.homeColorLight,
                                   homeColorDark: Default.homeColor,
                                   perfectColor: Default.perfectColor,
                                   perfectColorDark: Default.perfectColorDark,
                                   majorColor: Default.majorColor,
                                   majorColorDark: Default.majorColorDark,
                                   minorColor: Default.minorColor,
                                   minorColorDark: Default.minorColorDark,
                                   tritoneColor: Default.tritoneColor,
                                   tritoneColorDark: Default.tritoneColorDark,
                                   mostKeysAreLight: true,
                                   homeKeyIsLight: true,
                                   linearLayout: linearLayout)
            }.cornerRadius(5)
        }
    }
}

struct SwiftUIKeyboardKey: View {
    @State var MIDIKeyPressed = [Bool](repeating: false, count: 128)
    
    var keyboardCell: KeyboardCell
    var pitch: Pitch
    var isActivated : Bool
    let labelType: LabelType
    var tonicPitchClass : Int
    let initialC: Int
    let homeColor: Color
    let homeColorDark: Color
    let perfectColor: Color
    let perfectColorDark: Color
    let majorColor: Color
    let majorColorDark: Color
    let minorColor: Color
    let minorColorDark: Color
    let tritoneColor: Color
    let tritoneColorDark: Color
    let mostKeysAreLight: Bool
    let homeKeyIsLight: Bool
    let linearLayout: Bool
    
    var body: some View {
        VStack{
            IntervallicKey(keyboardCell: keyboardCell,
                           pitch: pitch,
                           isActivated: isActivated,
                           labelType: labelType,
                           initialC: 48,
                           tonicPitchClass: tonicPitchClass,
                           homeColor: homeColor,
                           homeColorDark: homeColorDark,
                           perfectColor: perfectColor,
                           perfectColorDark: perfectColorDark,
                           majorColor: majorColor,
                           majorColorDark: majorColorDark,
                           minorColor: minorColor,
                           minorColorDark: minorColorDark,
                           tritoneColor: tritoneColor,
                           tritoneColorDark: tritoneColorDark,
                           mostKeysAreLight: mostKeysAreLight,
                           homeKeyIsLight: homeKeyIsLight,
                           linearLayout: linearLayout,
                           flatTop: true,
                           isActivatedExternally: MIDIKeyPressed[pitch.intValue])
        }.onReceive(NotificationCenter.default.publisher(for: .MIDIKey), perform: { obj in
            if let userInfo = obj.userInfo, let info = userInfo["info"] as? UInt8, let val = userInfo["bool"] as? Bool {
                if (info >= 0 && info <= 127) {
                    self.MIDIKeyPressed[Int(info)] = val
                }
            }
        })
    }
}
