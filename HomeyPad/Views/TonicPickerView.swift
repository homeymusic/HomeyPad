import SwiftUI

struct TonicPickerView: View {
    @StateObject var viewConductor: ViewConductor
    @State private var showSettings = false
    
    var body: some View {
        HStack(spacing: 3.0) {
            ForEach(-6...6, id: \.self) { tonic in
                Button {
                } label: {
                    let pitch = viewConductor.allPitches[viewConductor.centerMIDI + tonic]
                    let interval = Interval(pitch: pitch, tonicPitch: viewConductor.tonicPitch)
                    viewConductor.mainColor
                        .aspectRatio(1.0, contentMode: .fit)
                        .overlay(
                            Text(pitch.letter(viewConductor.accidentalChoice))
                                .foregroundColor(Color(interval.majorMinor.color))
                                .font(Font.system(size: 20, design: .monospaced))
                        )
                }
            }
        }
        .padding(7.0)
        .background {
            RoundedRectangle(cornerRadius: 5.0)
                .fill(Color(UIColor.systemGray5))
        }
    }
}
