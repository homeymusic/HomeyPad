import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct ModePickerView: View {
    // Update the closure to include the columnIndex parameter.
    @ObservedObject var modeConductor: ViewConductor
    @EnvironmentObject var tonalContext: TonalContext
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tonalContext.modePickerModes.indices, id: \.self) { index in
                let mode = tonalContext.modePickerModes[index]
                ModeContainerView(conductor: modeConductor,
                                  mode: mode,
                                  columnIndex: index)
            }
        }
        .animation(modeConductor.animationStyle, value: tonalContext.mode)
        .clipShape(Rectangle())
    }
}
