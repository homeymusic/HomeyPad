import SwiftUI
import HomeyMusicKit

struct HeaderView: View {
    @EnvironmentObject var notationalTonicContext: NotationalTonicContext
    
    var body: some View {
        HStack {
            HStack(spacing: 0.0) {
                OctaveShiftView()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            TonicPickerSettingsView()
            HStack(spacing: 15) {
                PitchDirectionPickerView()
                HelpView()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
