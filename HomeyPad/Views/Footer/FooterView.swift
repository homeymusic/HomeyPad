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
    @Environment(AppContext.self)  private var appContext

    private var instrument: any MusicalInstrument {
        modelContext.singletonInstrument(for: appContext.instrumentType)
    }

    var body: some View {
        @Bindable var appContext = appContext
        HStack {
            HStack {
                Button(action: {
                    withAnimation {
                        instrument.latching.toggle()
                        buzz()
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
                .id(appContext.instrumentType)
            }
            
            HStack {
                if instrument.instrumentType.isStringInstrument {
                    Picker("", selection: $appContext.instrumentType) {
                        ForEach(InstrumentType.stringInstruments) { stringInstrument in
                            Text(stringInstrument.label.capitalized)
                                .tag(stringInstrument)
                        }
                    }
                    .pickerStyle(.segmented)
                } else if let keyboardInstrument = instrument as? KeyboardInstrument {
                    RowsColsPickerView(
                        keyboardInstrument: keyboardInstrument
                    )
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .animation(HomeyMusicKit.animationStyle, value: appContext.instrumentType)
        }
    }
}

