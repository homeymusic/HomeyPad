import SwiftUI
import AVFoundation
import HomeyMusicKit

@main
struct HomeyPad: App {
    
    @StateObject private var appContext: InstrumentContext
    @StateObject private var tonalContext: TonalContext
    @StateObject private var midiContext: MIDIContext

    init() {
        // Initialize appContext and tonalContext as local variables.
        let appCtx = InstrumentContext()
        let tonalCtx = TonalContext()
        
        // Now assign them to the state objects using the underscore syntax.
        _appContext = StateObject(wrappedValue: appCtx)
        _tonalContext = StateObject(wrappedValue: tonalCtx)
        
        // Now it's safe to use them to initialize midiContext.
        _midiContext = StateObject(wrappedValue: MIDIContext(
            tonalContext: tonalCtx,
            instrumentMIDIChannelProvider: { appCtx.instrumentType.rawValue },
            tonicMIDIChannel: TonicPicker.tonic.rawValue,
            clientName: "HomeyPad",
            model: "Homey Pad iOS",
            manufacturer: "Homey Music"
        ))
        
        // You can also add callbacks now.
        tonalCtx.addDidSetTonicPitchCallbacks { oldTonicPitch, newTonicPitch in
            if oldTonicPitch != newTonicPitch {
                buzz()
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(appContext: appContext, tonalContext: tonalContext)
                .environmentObject(appContext)
                .environmentObject(tonalContext)
                .environmentObject(midiContext)
        }
    }
    
    enum FormFactor {
        case iPad
        case iPhone
    }

    static let formFactor: FormFactor = UIScreen.main.bounds.size.width > 1000 ? .iPad : .iPhone
    static let primaryColor: CGColor = #colorLiteral(red: 0.4, green: 0.2666666667, blue: 0.2, alpha: 1)
    static let secondaryColor: CGColor = #colorLiteral(red: 0.9529411765, green: 0.8666666667, blue: 0.6705882353, alpha: 1)
    static let goldenRatio = (1 + sqrt(5)) / 2

}
