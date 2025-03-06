//
//  KeyboardLayoutPickerView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/24/24.
//

import SwiftUI
import HomeyMusicKit

struct FooterView: View {
    @ObservedObject var viewConductor: ViewConductor

    @EnvironmentObject var appContext: AppContext

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                withAnimation {
                    viewConductor.latching.toggle()
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: viewConductor.latching ? "pin.fill" : "pin.slash")
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: viewConductor.latching ? .black : .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            LayoutAndPalletePickerView(
                viewConductor: viewConductor
            )
            .id(appContext.instrument)
            
            HStack {
                if appContext.instrument.isStringInstrument {
                    Picker("", selection: $appContext.instrument) {
                        ForEach(Instrument.stringInstruments) { stringInstrument in
                            Text(stringInstrument.label.capitalized)
                                .tag(stringInstrument)
                        }
                    }
                    .pickerStyle(.segmented)
                } else {
                    RowsColsPickerView(viewConductor: viewConductor)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .animation(viewConductor.animationStyle, value: viewConductor.layoutChoice)
        }
    }
}

