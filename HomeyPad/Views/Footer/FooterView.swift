//
//  KeyboardLayoutPickerView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/24/24.
//

import SwiftUI
import HomeyMusicKit

struct FooterView: View {
    @EnvironmentObject var instrumentalContext: InstrumentalContext
    @EnvironmentObject var tonalContext: TonalContext

    var body: some View {
        HStack {
            HStack {
                Button(action: {
                    withAnimation {
                        instrumentalContext.toggleLatching(with: tonalContext)
                    }
                }) {
                    ZStack {
                        Color.clear.overlay(
                            Image(systemName: instrumentalContext.latching ? "pin.fill" : "pin.slash")
                                .foregroundColor(.white)
                                .font(Font.system(size: .leastNormalMagnitude, weight: instrumentalContext.latching ? .black : .thin))
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
                InstrumentAndPalletePickerView()
                .id(instrumentalContext.instrumentChoice)
            }
            
            HStack {
                if instrumentalContext.instrumentChoice.isStringInstrument {
                    Picker("", selection: $instrumentalContext.instrumentChoice) {
                        ForEach(InstrumentChoice.stringInstruments) { stringInstrument in
                            Text(stringInstrument.label.capitalized)
                                .tag(stringInstrument)
                        }
                    }
                    .pickerStyle(.segmented)
                } else {
                    RowsColsPickerView(
                        keyboardInstrument: instrumentalContext.keyboardInstrument
                    )
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .animation(HomeyMusicKit.animationStyle, value: instrumentalContext.instrumentChoice)
        }
    }
}

