import SwiftUI

@MainActor
@Observable
public final class AppContext {
    public var showModePicker: Bool = false
    public var showTonicPicker: Bool = false
    public var showLabelsPopover: Bool = false
    public var showColorPalettePopover: Bool = false
    public var showEditColorPaletteSheet: Bool = false
    public var showTonicModeLabelsPopover: Bool = false
    public var showHelp: Bool = false
}
