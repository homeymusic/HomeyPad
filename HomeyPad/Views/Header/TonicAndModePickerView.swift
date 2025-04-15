import SwiftUI
import HomeyMusicKit

struct TonicAndModePickerView: View {
    @Environment(InstrumentalContext.self) var instrumentalContext
    @Environment(NotationalTonicContext.self) var notationalTonicContext
    let horizontalCellCount = 13.0

    var body: some View {
        if isModeOrTonicPickersShown {
            HStack(spacing: 5) {
                modeAndTonicPickerToggleView(feetDirection: .right)
                VStack(spacing: 5) {
                    if notationalTonicContext.showTonicPicker {
                        TonicInstrumentView()
                            .aspectRatio(horizontalCellCount, contentMode: .fit)
                    }
                    if notationalTonicContext.showModePicker {
                        ModeInstrumentView()
                            .aspectRatio(horizontalCellCount * aspectMultiplier, contentMode: .fit)
                    }
                }
                modeAndTonicPickerToggleView(feetDirection: .left)
            }
            // Lock the entire TonicAndModePickerView to the ratio we computed
            .aspectRatio(ratio, contentMode: .fit)
        } else {
            EmptyView()
        }
    }
    
    func modeAndTonicPickerToggleView(feetDirection: FeetDirection) -> some View {
        Button(action: {
            withAnimation {
                print("areModeAndTonicLinked", instrumentalContext.areModeAndTonicLinked)
                instrumentalContext.areModeAndTonicLinked.toggle()
                buzz()
            }
        }) {
            ZStack {                
                Group {
                    let strokeStyle = StrokeStyle(
                        lineWidth: 1,
                        dash: instrumentalContext.areModeAndTonicLinked ? [] : [8, 2]
                    )
                    switch feetDirection {
                    case .left:
                        VerticalLineWithFeet(direction: .right)
                            .stroke(style: strokeStyle)
                            .foregroundColor(areModeAndTonicPickersShown ? .white : .clear)
                    case .right:
                        VerticalLineWithFeet(direction: .left)
                            .stroke(style: strokeStyle)
                            .foregroundColor(areModeAndTonicPickersShown ? .white : .clear)
                    }
                }
                if  instrumentalContext.areModeAndTonicLinked {
                    Image(systemName: "personalhotspot.circle.fill")
                        .font(Font.system(.title2, weight: .black))
                        .foregroundColor(areModeAndTonicPickersShown ? .white : .clear)
                        .background(
                            // The overlay draws a white border around the padded background
                            Rectangle()
                                .fill(areModeAndTonicPickersShown ? .black : .clear)
                        )
                } else {
                    HomeyMusicKit.modeAndTonicUnlinkedImage
                        .font(Font.system(.title2, weight: .thin))
                        .foregroundColor(areModeAndTonicPickersShown ? .white : .clear)
                        .background(
                            // The overlay draws a white border around the padded background
                            Rectangle()
                                .fill(areModeAndTonicPickersShown ? .black : .clear)
                        )
                }
            }
            .aspectRatio(1/2, contentMode: .fit)
            .padding([.top, .bottom], 16)
        }
    }
    
    var ratio : CGFloat {
        if areModeAndTonicPickersShown {
            return horizontalCellCount / (areBothModeNoteLabelsShown ? 2.0 : 1.5)
        } else if notationalTonicContext.showModePicker {
            return horizontalCellCount  * aspectMultiplier
        } else {
            return horizontalCellCount
        }
    }
    
    var areModeAndTonicPickersShown: Bool {
        notationalTonicContext.showModePicker &&
        notationalTonicContext.showTonicPicker
    }
    
    var isModeOrTonicPickersShown: Bool {
        notationalTonicContext.showModePicker ||
        notationalTonicContext.showTonicPicker
    }
    
    var areBothModeNoteLabelsShown: Bool {
        notationalTonicContext.noteLabels[.tonicPicker]![.mode]! &&
        notationalTonicContext.noteLabels[.tonicPicker]![.map]!
    }
    /// Example multiplier used for the Mode instrument's aspect ratio
    var aspectMultiplier: CGFloat {
        // For example, if certain label combos are visible,
        // you might want the ModeInstrumentView to be "double height"
        // or "the same height" etc.
        if areBothModeNoteLabelsShown {
            return 1.0
        } else {
            return 2.0
        }
    }
    
    enum FeetDirection {
        case left
        case right
    }

    struct VerticalLineWithFeet: Shape {
        let direction: FeetDirection

        func path(in rect: CGRect) -> Path {
            var path = Path()

            let centerX = rect.midX
            let topY = rect.minY
            let bottomY = rect.maxY
            let edgeX = direction == .left ? rect.maxX : rect.minX

            // Vertical line
            path.move(to: CGPoint(x: centerX, y: topY))
            path.addLine(to: CGPoint(x: centerX, y: bottomY))

            // Top foot
            path.move(to: CGPoint(x: centerX, y: topY))
            path.addLine(to: CGPoint(x: edgeX, y: topY))

            // Bottom foot
            path.move(to: CGPoint(x: centerX, y: bottomY))
            path.addLine(to: CGPoint(x: edgeX, y: bottomY))

            return path
        }
    }
}
