import SwiftUI

struct TonicPickerView: View {
    @StateObject var viewConductor: ViewConductor
    @State private var showSettings = false
    
    var body: some View {
        HStack(spacing: 3.0) {
            Color.clear
                .aspectRatio(1.0, contentMode: .fit)
                .overlay(
                    GeometryReader { proxy in
                        VStack {
                            ConsonanceDissonance.NitterHouseWithDoor()
                                .aspectRatio(1.0, contentMode: .fit)
                                .foregroundColor(.black)
                                .frame(height: proxy.size.height * 0.4)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                )
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
            Color.clear
                .aspectRatio(1.0, contentMode: .fit)
                .overlay(
                    GeometryReader { proxy in
                        VStack {
                            ConsonanceDissonance.NitterHouse()
                                .aspectRatio(1.0, contentMode: .fit)
                                .foregroundColor(.black)
                                .frame(height: proxy.size.height * 0.4)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                )
        }
        .padding(4.0)
        .background {
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(Color(UIColor.systemGray6), lineWidth: 3.0)
                .fill(Color(UIColor.systemGray5))
        }
    }
}
