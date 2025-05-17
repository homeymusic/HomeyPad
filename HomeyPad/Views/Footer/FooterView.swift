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

    @Environment(SynthConductor.self) private var synthConductor
    @Environment(MIDIConductor.self)  private var midiConductor

    private var musicalInstrument: MusicalInstrument {
        modelContext.singletonInstrument(
            for: appContext.instrumentType,
            midiConductor: midiConductor,
            synthConductor: synthConductor
        )
    }

    var body: some View {
        @Bindable var appContext = appContext
        HStack {
            HStack {
                Button(action: {
                    withAnimation {
                        musicalInstrument.latching.toggle()
                        buzz()
                    }
                }) {
                    ZStack {
                        Color.clear.overlay(
                            Image(systemName: musicalInstrument.latching ? "pin.fill" : "pin.slash")
                                .foregroundColor(.white)
                                .font(Font.system(size: .leastNormalMagnitude, weight: musicalInstrument.latching ? .black : .thin))
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                    }
                }

                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
                NotationInstrumentPalletePickerView(tonalityInstrument: modelContext.tonalityInstrument(midiConductor: midiConductor))
                .id(appContext.instrumentType)
            }
            
            HStack {
                if appContext.instrumentType.isStringInstrument {
                    Picker("", selection: $appContext.instrumentType) {
                        ForEach(InstrumentType.stringInstruments) { stringInstrument in
                            Text(stringInstrument.label.capitalized)
                                .tag(stringInstrument)
                        }
                    }
                    .pickerStyle(.segmented)
                } else if let keyboardInstrument = musicalInstrument as? KeyboardInstrument {
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

