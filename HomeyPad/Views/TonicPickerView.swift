import SwiftUI

struct TonicPickerView: View {
    @StateObject var viewConductor: ViewConductor
    @State private var showSettings = false
    
    var body: some View {
        HStack {
            ForEach(-6...6, id: \.self) { tonic in
                Button {
                } label: {
                    let pitch = viewConductor.allPitches[viewConductor.centerMIDI + tonic]
                    let interval = Interval(pitch: pitch, tonicPitch: viewConductor.tonicPitch)
                    viewConductor.mainColor
                        .aspectRatio(1.0, contentMode: .fit)
                        .overlay(
                            Text(pitch.letter)
                                .foregroundColor(Color(interval.majorMinor.color))
                        )
                }
            }
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(UIColor.systemGray5))
        }
    }
}
