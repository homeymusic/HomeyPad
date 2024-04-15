import SwiftUI

struct RowsColsPickerView: View {
    @StateObject var viewConductor: ViewConductor

    var body: some View {
        HStack(spacing: 7.0) {
            Button(action: {
                viewConductor.fewerRows()
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: "arrow.down.and.line.horizontal.and.arrow.up")
                            .foregroundColor(viewConductor.showFewerRows ? .white : .gray)
                            .font(Font.system(size: .leastNormalMagnitude, weight: viewConductor.showFewerRows ? .regular : .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .disabled(!viewConductor.showFewerRows)
            
            Divider()
                .frame(width: 1, height: 17.5)
                .overlay(Color(UIColor.systemGray4))
            
            Button(action: {
                viewConductor.moreRows()
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: "arrow.up.and.line.horizontal.and.arrow.down")
                            .foregroundColor(viewConductor.showMoreRows ? .white : .gray)
                            .font(Font.system(size: .leastNormalMagnitude, weight: viewConductor.showMoreRows ? .regular : .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .disabled(!viewConductor.showMoreRows)
            
            Button(action: {
                viewConductor.resetRowsColsPerSide()
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: "gobackward")
                            .foregroundColor(viewConductor.showRowColsReset ? .white : .gray)
                            .font(Font.system(size: .leastNormalMagnitude, weight: viewConductor.showRowColsReset ? .regular : .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .disabled(!viewConductor.showRowColsReset)
            
            Button(action: {
                viewConductor.fewerCols()
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: "arrow.right.and.line.vertical.and.arrow.left")
                            .foregroundColor(viewConductor.showFewerColumns ? .white : .gray)
                            .font(Font.system(size: .leastNormalMagnitude, weight: viewConductor.showFewerColumns ? .regular : .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .disabled(!viewConductor.showFewerColumns)
            
            Divider()
                .frame(width: 1, height: 17.5)
                .overlay(Color(UIColor.systemGray4))
            
            Button(action: {
                viewConductor.moreCols()
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: "arrow.left.and.line.vertical.and.arrow.right")
                            .foregroundColor(viewConductor.showMoreColumns ? .white : .gray)
                            .font(Font.system(size: .leastNormalMagnitude, weight: viewConductor.showMoreColumns ? .regular : .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .disabled(!viewConductor.showMoreColumns)
        }
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(UIColor.systemGray6))
        )
    }
}
