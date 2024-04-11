import SwiftUI

struct TonicPickerView: View {
    @StateObject var viewConductor: ViewConductor
    @State private var showSettings = false

    var body: some View {
        HStack(spacing: 3.0) {
            ForEach(-6...6, id: \.self) { tonic in
                ZStack {
                    GeometryReader { proxy in
                        Button {
                        } label: {
                            viewConductor.mainColor
//                                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                                            .overlay(LabelView(viewConductor: viewConductor,
//                                                                               pitch: viewConductor.allPitches[tonic],
//                                                                               interval: Interval(pitch: viewConductor.allPitches[tonic], tonicPitch: viewConductor.tonicPitch),
//                                                                               proxySize: proxy.size))
                        }
                    }
                }
                .aspectRatio(1.0, contentMode: .fit)
            }
        }
        .padding(7.0)
        .background {
            RoundedRectangle(cornerRadius: 5.0)
                .fill(Color(UIColor.systemGray6))
        }
    }
}
