import SwiftUI
import HomeyMusicKit
import MIDIKitCore

struct ModePickerView<Content>: View where Content: View {
    let modeView: (Mode) -> Content
    
    @ObservedObject var modeConductor: ViewConductor
    @ObservedObject var tonalContext: TonalContext
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tonalContext.modePickerModes, id: \.self) { mode in
                ModeContainerView(conductor: modeConductor,
                                  mode: mode,
                                  modeView: modeView)
            }
        }
        .animation(modeConductor.animationStyle, value: tonalContext.mode)
        .clipShape(Rectangle())
    }
}
