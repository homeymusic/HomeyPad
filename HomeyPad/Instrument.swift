import SwiftUI
import MIDIKitIO
public typealias MIDIChannel = UInt4

public enum Instrument: MIDIChannel, CaseIterable, Identifiable, Codable {
    case isomorphic = 0
    case symmetric  = 1
    case piano      = 2
    case violin     = 3
    case cello      = 4
    case bass       = 5
    case banjo      = 6
    case guitar     = 7
    case tonic      = 15

    public var id: Self { self }
    
    public var label: String {
        String(describing: self)
    }
    
    public var icon: String {
        switch self {
        case .isomorphic: return "rectangle.split.2x1"
        case .symmetric:  return "rectangle.split.2x2"
        case .piano:      return "guitars"
        case .violin:     return "guitars"
        case .cello:      return "guitars"
        case .bass:       return "guitars"
        case .banjo:      return "guitars"
        case .guitar:     return "guitars"
        case .tonic:      return "house"
        }
    }
}
