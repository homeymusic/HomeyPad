import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct ModePickerView<Content>: View where Content: View {
    // Update the closure to include the columnIndex parameter.
    let modeView: (Mode, Int) -> Content
    
    @ObservedObject var modeConductor: ViewConductor
    @ObservedObject var tonalContext: TonalContext
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tonalContext.modePickerModes.indices, id: \.self) { index in
                let mode = tonalContext.modePickerModes[index]
                ModeContainerView(conductor: modeConductor,
                                  mode: mode,
                                  columnIndex: index,
                                  modeView: modeView)
            }
        }
        .animation(modeConductor.animationStyle, value: tonalContext.mode)
        .clipShape(Rectangle())
    }
}
