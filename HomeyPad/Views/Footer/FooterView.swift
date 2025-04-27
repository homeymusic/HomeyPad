//
//  KeyboardLayoutPickerView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/24/24.
//

import SwiftUI
import HomeyMusicKit

struct FooterView: View {
    
    @Environment(\.modelContext)            private var modelContext
    @Environment(InstrumentalContext.self)  private var instrumentalContext
    
    private var instrument: any Instrument {
        modelContext.instrument(for: instrumentalContext.instrumentChoice)
    }

    var body: some View {
        @Bindable var instrumentalContext = instrumentalContext
        HStack {
            HStack {
                Button(action: {
                    withAnimation {
                        instrument.latching.toggle()
                    }
                }) {
                    ZStack {
                        Color.clear.overlay(
                            Image(systemName: instrument.latching ? "pin.fill" : "pin.slash")
                                .foregroundColor(.white)
                                .font(Font.system(size: .leastNormalMagnitude, weight: instrument.latching ? .black : .thin))
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                    }
                }

                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
                NotationInstrumentPalletePickerView()
                .id(instrumentalContext.instrumentChoice)
            }
            
            HStack {
                if instrument.instrumentChoice.isStringInstrument {
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

