import SwiftUI
import HomeyMusicKit

struct HelpView: View {
    @Environment(AppContext.self) var appContext
    
    var body: some View {
        @Bindable var appContext = appContext

        let icon = "questionmark.circle"
        HStack(spacing: 0) {
            Button(action: {
                withAnimation {
                    appContext.showHelp.toggle()
                }
            }) {
                ZStack {
                    Color.clear.overlay(
                        Image(systemName: appContext.showHelp ? icon + ".fill" : icon)
                            .foregroundColor(.white)
                            .font(Font.system(size: .leastNormalMagnitude, weight: .thin))
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .popover(isPresented: $appContext.showHelp, content: {
                VStack(spacing: 0) {
                    HelpPopoverView().presentationCompactAdaptation(.none)
                }
            })
        }
    }
}


