import SwiftUI
import AVFoundation
import HomeyMusicKit

@main
struct HomeyPad: App {
    
    @StateObject private var instrumentalContext: InstrumentalContext
    @StateObject private var tonalContext: TonalContext
    @StateObject private var notationalContext: NotationalContext
    @StateObject private var notationalTonicContext: NotationalTonicContext
    @StateObject private var midiContext: MIDIContext

    init() {
        // Initialize appContext and tonalContext as local variables.
        let instrumentalContext = InstrumentalContext()
        let tonalContext = TonalContext()
        let notationalContext = NotationalContext()
        let notationalTonicContext = NotationalTonicContext()

        // Now assign them to the state objects using the underscore syntax.
        _instrumentalContext = StateObject(wrappedValue: instrumentalContext)
        _tonalContext = StateObject(wrappedValue: tonalContext)
        _notationalContext = StateObject(wrappedValue: notationalContext)
        _notationalTonicContext = StateObject(wrappedValue: notationalTonicContext)

        // You can also add callbacks now.
        tonalContext.addDidSetTonicPitchCallbacks { oldTonicPitch, newTonicPitch in
            if oldTonicPitch != newTonicPitch {
                buzz()
            }
        }

        // Now it's safe to use them to initialize midiContext.
        _midiContext = StateObject(wrappedValue: MIDIContext(
            tonalContext: tonalContext,
            instrumentMIDIChannelProvider: { instrumentalContext.instrumentType.rawValue },
            tonicMIDIChannel: InstrumentType.tonicPicker.rawValue,
            clientName: "HomeyPad",
            model: "Homey Pad iOS",
            manufacturer: "Homey Music"
        ))
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                tonalContext: tonalContext,
                instrumentalContext: instrumentalContext,
                notationalTonicContext: notationalTonicContext
            )
                .environmentObject(instrumentalContext)
                .environmentObject(tonalContext)
                .environmentObject(notationalContext)
                .environmentObject(notationalTonicContext)            
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
