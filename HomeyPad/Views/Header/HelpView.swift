import SwiftUI
import HomeyMusicKit

struct HelpView: View {
    @Environment(NotationalTonicContext.self) var notationalTonicContext

    static let icon = "questionmark.circle"
    
    var body: some View {
        @Bindable var notationalTonicContext = notationalTonicContext
        HStack(spacing: 0) {
            Button(action: {
                withAnimation {
                    notationalTonicContext.showHelp.toggle()
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: notationalTonicContext.showHelp ? HelpView.icon + ".fill" : HelpView.icon)
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .popover(isPresented: $notationalTonicContext.showHelp, content: {
                VStack(spacing: 0) {
                    HelpPopoverView().presentationCompactAdaptation(.popover)
                }
            })
        }
    }
}


