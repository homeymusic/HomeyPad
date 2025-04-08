//
//  KeyboardLayoutPickerView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/24/24.
//

import SwiftUI
import HomeyMusicKit

struct FooterView: View {
    @Environment(InstrumentalContext.self) var instrumentalContext
    @Environment(TonalContext.self) var tonalContext

    var body: some View {
        @Bindable var instrumentalContext = instrumentalContext
        HStack {
            HStack {
                Button(action: {
                    withAnimation {
                        instrumentalContext.latching.toggle()
                    }
                }) {
                    ZStack {
                        Color.clear.overlay(
                            Image(systemName: instrumentalContext.latching ? "pin.fill" : "pin.slash")
                                .foregroundColor(.accentColor)
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
            .foregroundColor(.accentColor)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .animation(HomeyMusicKit.animationStyle, value: instrumentalContext.instrumentChoice)
        }
    }
}

