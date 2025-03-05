import SwiftUI
import HomeyMusicKit

final class AppContext: ObservableObject {
    let appDefaults = UserDefaults.standard

    @Published var layoutChoice: LayoutChoice
    @Published var stringsLayoutChoice: StringsLayoutChoice

    init() {
        let defaultLayoutChoice: LayoutChoice = .symmetric
        
        appDefaults.register(defaults: [
            "layoutChoice": defaultLayoutChoice.rawValue
        ])
        
        self.layoutChoice = LayoutChoice(
            rawValue: appDefaults.string(forKey: "layoutChoice") ?? defaultLayoutChoice.rawValue
        ) ?? defaultLayoutChoice
        
        // String Instruments Sub Layout
        let defaultStringsLayoutChoice: StringsLayoutChoice = .violin
        appDefaults.register(defaults: [
            "stringsLayoutChoice": defaultStringsLayoutChoice.rawValue
        ])
        self.stringsLayoutChoice = StringsLayoutChoice(
            rawValue: appDefaults.string(forKey: "stringsLayoutChoice") ?? defaultStringsLayoutChoice.rawValue
        ) ?? defaultStringsLayoutChoice
    }
}
