import SwiftUI
import AVFoundation
import HomeyMusicKit

struct ContentView: View {
    let defaults = UserDefaults.standard
    @StateObject private var tonicConductor: TonicConductor
    @StateObject private var modeConductor: ViewConductor
    @StateObject private var viewConductor: ViewConductor

    @State var showTonicPicker: Bool
    
    let appContext: InstrumentContext
    let tonalContext: TonalContext

    init(appContext: InstrumentContext, tonalContext: TonalContext) {
        self.appContext = appContext
        self.tonalContext = tonalContext

        // Set up for encoding and decoding the user default dictionaries
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        // Accidental
        let defaultAccidental: Accidental = .default
        defaults.register(defaults: [
            "accidental" : defaultAccidental.rawValue
        ])
        let accidental: Accidental = Accidental(rawValue: defaults.integer(forKey: "accidental")) ?? defaultAccidental
        
        // Show Tonic Picker
        defaults.register(defaults: [
            "showTonicPicker" : false
        ])
        showTonicPicker = defaults.bool(forKey: "showTonicPicker")
        
        // Latching
        defaults.register(defaults: [
            "latching" : false
        ])
        let latching = defaults.bool(forKey: "latching")
        
        // Set up for layout palettes
        let defaultLayoutPalette = LayoutPalette()
        
        // Palette selection for each layout in main view
        if let encodedDefaultLayoutPalette = try? encoder.encode(defaultLayoutPalette) {
            defaults.register(defaults: [
                "viewLayoutPalette" : encodedDefaultLayoutPalette
            ])
        }
        var viewLayoutPalette: LayoutPalette = defaultLayoutPalette
        if let savedViewLayoutPalette = defaults.object(forKey: "viewLayoutPalette") as? Data {
            if let loadedViewLayoutPalette = try? decoder.decode(LayoutPalette.self, from: savedViewLayoutPalette) {
                viewLayoutPalette = loadedViewLayoutPalette
            }
        }
        
        // Note label selections
        let defaultLayoutLabel = LayoutLabel()
        
        if let encodedDefaultLayoutLabel = try? encoder.encode(defaultLayoutLabel) {
            defaults.register(defaults: [
                "tonicLayoutLabel" : encodedDefaultLayoutLabel
            ])
        }
        var tonicLayoutLabel: LayoutLabel = defaultLayoutLabel
        if let savedTonicLayoutLabel = defaults.object(forKey: "tonicLayoutLabel") as? Data {
            if let loadedTonicLayoutLabel = try? decoder.decode(LayoutLabel.self, from: savedTonicLayoutLabel) {
                tonicLayoutLabel = loadedTonicLayoutLabel
            }
        }
        
        if let encodedDefaultLayoutLabel = try? encoder.encode(defaultLayoutLabel) {
            defaults.register(defaults: [
                "modeLayoutLabel" : encodedDefaultLayoutLabel
            ])
        }
        var modeLayoutLabel: LayoutLabel = defaultLayoutLabel
        if let savedModeLayoutLabel = defaults.object(forKey: "modeLayoutLabel") as? Data {
            if let loadedModeLayoutLabel = try? decoder.decode(LayoutLabel.self, from: savedModeLayoutLabel) {
                modeLayoutLabel = loadedModeLayoutLabel
            }
        }
        
        if let encodedDefaultLayoutLabel = try? encoder.encode(defaultLayoutLabel) {
            defaults.register(defaults: [
                "viewLayoutLabel" : encodedDefaultLayoutLabel
            ])
        }
        var viewLayoutLabel: LayoutLabel = defaultLayoutLabel
        if let savedViewLayoutLabel = defaults.object(forKey: "viewLayoutLabel") as? Data {
            if let loadedViewLayoutLabel = try? decoder.decode(LayoutLabel.self, from: savedViewLayoutLabel) {
                viewLayoutLabel = loadedViewLayoutLabel
            }
        }
        
        // Rows and columns picker for each layout in main view except strings
        let defaultLayoutRowsCols = LayoutRowsCols()
        if let encodedDefaultLayoutRowsCols = try? encoder.encode(defaultLayoutRowsCols) {
            defaults.register(defaults: [
                "layoutRowsCols" : encodedDefaultLayoutRowsCols
            ])
        }
        var layoutRowsCols: LayoutRowsCols = defaultLayoutRowsCols
        if let savedLayoutRowsCols = defaults.object(forKey: "layoutRowsCols") as? Data {
            if let loadedLayoutRowsCols = try? decoder.decode(LayoutRowsCols.self, from: savedLayoutRowsCols) {
                layoutRowsCols = loadedLayoutRowsCols
            }
        }
        
        viewLayoutPalette.choices[.tonic] = viewLayoutPalette.choices[.zeena]
        viewLayoutPalette.outlineChoice[.tonic] = viewLayoutPalette.outlineChoice[.zeena]
               
        _tonicConductor = StateObject(wrappedValue: TonicConductor(
            accidental: accidental,
            layoutPalette: viewLayoutPalette,
            layoutLabel: tonicLayoutLabel,
            tonalContext: tonalContext
        ))
        
        _modeConductor = StateObject(wrappedValue: ViewConductor(
            accidental: accidental,
            layoutChoice: .mode,
            layoutPalette: viewLayoutPalette,
            layoutLabel: modeLayoutLabel,
            sendTonicState: false,
            tonalContext: tonalContext
        ))
        
        _viewConductor = StateObject(wrappedValue: ViewConductor(
            accidental: accidental,
            layoutChoice: .zeena,
            stringsLayoutChoice: .banjo,
            latching: latching,
            layoutPalette: viewLayoutPalette,
            layoutLabel: viewLayoutLabel,
            layoutRowsCols: layoutRowsCols,
            sendTonicState: false,
            tonalContext: tonalContext
        ))
        
    }
    
    var body: some View {
        let settingsHeight = 30.0
        GeometryReader { proxy in
            ZStack {
                Color.black
                ZStack() {
                    // Header
                    VStack {
                        HeaderView(viewConductor: viewConductor,
                                   tonicConductor: tonicConductor,
                                   modeConductor: modeConductor,
                                   showTonicPicker: $showTonicPicker)
                            .frame(height: settingsHeight)
                        Spacer()
                    }
                    // Tonic Picker & Keyboard
                    VStack {
                        // Tonic Picker
                        if showTonicPicker && (tonicConductor.showTonicLabels || modeConductor.showModes) {
                            VStack {
                                
                                if tonicConductor.showTonicLabels {
                                    TonicKeyboardView(
                                        tonicConductor: tonicConductor
                                    ) { pitch in
                                        PitchView(
                                            pitch: pitch,
                                            thisConductor: tonicConductor,
                                            tonicConductor: tonicConductor,
                                            viewConductor: viewConductor,
                                            modeConductor: modeConductor
                                        )
                                        .aspectRatio(1.0, contentMode: .fit)
                                    }
                                    .aspectRatio(13.0, contentMode: .fit)
                                    .transition(.scale(.leastNonzeroMagnitude, anchor: .bottom))
                                }
                                
                                if modeConductor.showModes {
                                    ModeKeyboardView(
                                        modeConductor: modeConductor
                                    ) { mode, columnIndex in
                                        ModeView(mode: mode,
                                                 columnIndex: columnIndex,
                                                 thisConductor: modeConductor,
                                                 viewConductor: viewConductor,
                                                 modeConductor: modeConductor
                                                 )
                                        .aspectRatio(2.0, contentMode: .fit)
                                    }
                                    .aspectRatio(13.0 * 2.0, contentMode: .fit)
                                    .transition(.scale(.leastNonzeroMagnitude, anchor: .bottom))
                                }
                                
                            }
                            .padding(7.0)
                            .background {
                                RoundedRectangle(cornerRadius: 7.0)
                                    .fill(Color(UIColor.systemGray6))
                            }
                        }
                        // Primary Keyboard View
                        if viewConductor.isOneRowOnTablet  {
                            InstrumentView(
                                conductor: viewConductor
                            ) { pitch in
                                PitchView(
                                    pitch: pitch,
                                    thisConductor: viewConductor,
                                    tonicConductor: tonicConductor,
                                    viewConductor: viewConductor,
                                    modeConductor: modeConductor
                                )
                            }
                            .aspectRatio(4.0, contentMode: .fit)
                            .ignoresSafeArea(edges:.horizontal)
                        }
                        
                        if !viewConductor.isOneRowOnTablet {
                            InstrumentView(
                                conductor: viewConductor
                            ) { pitch in
                                PitchView(
                                    pitch: pitch,
                                    thisConductor: viewConductor,
                                    tonicConductor: tonicConductor,
                                    viewConductor: viewConductor,
                                    modeConductor: modeConductor
                                )
                            }
                            .ignoresSafeArea(edges:.horizontal)
                        }
                    }
                    .frame(height: .infinity)
                    .padding([.top, .bottom], settingsHeight + 5.0)
                    // Footer
                    VStack {
                        Spacer()
                        FooterView(
                            viewConductor: viewConductor
                        )
                            .frame(height: settingsHeight)
                    }
                    
                }
            }
            .statusBarHidden(true)
            .background(.black)
            .onChange(of: tonicConductor.accidental) {
                viewConductor.accidental = tonicConductor.accidental
                defaults.set(tonicConductor.accidental.rawValue, forKey: "accidental")
                defaults.set(viewConductor.accidental.rawValue, forKey: "accidental")
            }
            .onChange(of: viewConductor.accidental) {
                tonicConductor.accidental = viewConductor.accidental
                defaults.set(viewConductor.accidental.rawValue, forKey: "accidental")
                defaults.set(tonicConductor.accidental.rawValue, forKey: "accidental")
            }
            .onChange(of: viewConductor.layoutChoice) {
                tonicConductor.layoutPalette.choices[.tonic] = viewConductor.layoutPalette.choices[viewConductor.layoutChoice]
                tonicConductor.layoutPalette.outlineChoice[.tonic] = viewConductor.layoutPalette.outlineChoice[viewConductor.layoutChoice]
                defaults.set(viewConductor.layoutChoice.rawValue, forKey: "layoutChoice")
            }
            .onChange(of: viewConductor.stringsLayoutChoice) {
                defaults.set(viewConductor.stringsLayoutChoice.rawValue, forKey: "stringsLayoutChoice")
            }
            .onChange(of: showTonicPicker) {
                defaults.set(showTonicPicker, forKey: "showTonicPicker")
            }
            .onChange(of: viewConductor.latching) {
                defaults.set(viewConductor.latching, forKey: "latching")
            }
            .onChange(of: viewConductor.layoutPalette) {
                tonicConductor.layoutPalette.choices[.tonic] = viewConductor.layoutPalette.choices[viewConductor.layoutChoice]
                tonicConductor.layoutPalette.outlineChoice[.tonic] = viewConductor.layoutPalette.outlineChoice[viewConductor.layoutChoice]
                if let encodedViewLayoutPalette = try? JSONEncoder().encode(viewConductor.layoutPalette) {
                    defaults.set(encodedViewLayoutPalette, forKey: "viewLayoutPalette")
                }
            }
            .onChange(of: tonicConductor.layoutLabel) {
                if let encodedTonicLayoutLabel = try? JSONEncoder().encode(tonicConductor.layoutLabel) {
                    defaults.set(encodedTonicLayoutLabel, forKey: "tonicLayoutLabel")
                }
            }
            .onChange(of: modeConductor.layoutLabel) {
                if let encodedModeLayoutLabel = try? JSONEncoder().encode(modeConductor.layoutLabel) {
                    defaults.set(encodedModeLayoutLabel, forKey: "modeLayoutLabel")
                }
            }
            .onChange(of: viewConductor.layoutLabel) {
                if let encodedViewLayoutLabel = try? JSONEncoder().encode(viewConductor.layoutLabel) {
                    defaults.set(encodedViewLayoutLabel, forKey: "viewLayoutLabel")
                }
            }
            .onChange(of: viewConductor.layoutRowsCols) {
                if let encodedLayoutRowsCols = try? JSONEncoder().encode(viewConductor.layoutRowsCols) {
                    defaults.set(encodedLayoutRowsCols, forKey: "layoutRowsCols")
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
