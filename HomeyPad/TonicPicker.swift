import SwiftUI
import MIDIKitIO
import HomeyMusicKit

public enum TonicPicker: MIDIChannel, CaseIterable, Identifiable, Codable {
    case tonic      = 15

    public var id: Self { self }
    
    public var label: String {
        String(describing: self)
    }
    
    public var icon: String {
        switch self {
        case .tonic: return "house"
        }
    }
}
