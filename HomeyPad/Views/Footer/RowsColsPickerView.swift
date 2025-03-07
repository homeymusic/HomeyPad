import SwiftUI
import HomeyMusicKit

struct RowsColsPickerView: View {
    @ObservedObject var viewConductor: ViewConductor
    @ObservedObject var keyboardInstrument: KeyboardInstrument
    
    @EnvironmentObject var tonalContext: TonalContext
   
    var body: some View {
        HStack(spacing: 7.0) {
            Button(action: {
                keyboardInstrument.fewerRows()
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: "arrow.down.and.line.horizontal.and.arrow.up")
                            .foregroundColor(keyboardInstrument.fewerRowsAreAvailable ? .white : .gray)
                            .font(Font.system(size: .leastNormalMagnitude, weight: keyboardInstrument.fewerRowsAreAvailable ? .regular : .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .disabled(!keyboardInstrument.fewerRowsAreAvailable)
            
            Divider()
                .frame(width: 1, height: 17.5)
                .overlay(Color(UIColor.systemGray4))
            
            Button(action: {
                keyboardInstrument.moreRows()
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: "arrow.up.and.line.horizontal.and.arrow.down")
                            .foregroundColor(keyboardInstrument.moreRowsAreAvailable ? .white : .gray)
                            .font(Font.system(size: .leastNormalMagnitude, weight: keyboardInstrument.moreRowsAreAvailable ? .regular : .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .disabled(!keyboardInstrument.moreRowsAreAvailable)
            
            Button(action: {
                keyboardInstrument.resetRowsCols()
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: "gobackward")
                            .foregroundColor(keyboardInstrument.rowColsAreNotDefault ? .white : .gray)
                            .font(Font.system(size: .leastNormalMagnitude, weight: keyboardInstrument.rowColsAreNotDefault ? .regular : .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .disabled(!keyboardInstrument.rowColsAreNotDefault)
            
            Button(action: {
                keyboardInstrument.fewerCols()
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: "arrow.right.and.line.vertical.and.arrow.left")
                            .foregroundColor(keyboardInstrument.fewerColsAreAvailable ? .white : .gray)
                            .font(Font.system(size: .leastNormalMagnitude, weight: keyboardInstrument.fewerColsAreAvailable ? .regular : .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .disabled(!keyboardInstrument.fewerColsAreAvailable)
            
            Divider()
                .frame(width: 1, height: 17.5)
                .overlay(Color(UIColor.systemGray4))
            
            Button(action: {
                keyboardInstrument.moreCols()
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: "arrow.left.and.line.vertical.and.arrow.right")
                            .foregroundColor(keyboardInstrument.moreColsAreAvailable ? .white : .gray)
                            .font(Font.system(size: .leastNormalMagnitude, weight: keyboardInstrument.moreColsAreAvailable ? .regular : .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .disabled(!keyboardInstrument.moreColsAreAvailable)
        }
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(UIColor.systemGray6))
        )
    }
}
