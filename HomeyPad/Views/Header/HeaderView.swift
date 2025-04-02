import SwiftUI
import HomeyMusicKit

struct HeaderView: View {
    @Environment(NotationalTonicContext.self) var notationalTonicContext
    
    var body: some View {
        HStack {
            HStack(spacing: 15) {
                ResetView()
                OctaveShiftView()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            TonicModePickerNotationView()
            HStack(spacing: 15) {
                PitchDirectionPickerView()
                HelpView()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
