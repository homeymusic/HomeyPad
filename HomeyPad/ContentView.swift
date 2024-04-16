import SwiftUI

struct ContentView: View {
    let defaults = UserDefaults.standard
    @State var showTonicPicker: Bool = false
    @StateObject private var tonicConductor: ViewConductor
    @StateObject private var viewConductor: ViewConductor

    init() {
        // Tonic MIDI
        let defaultTonicMIDI: Int = 60
        defaults.register(defaults: [
            "tonicMIDI" : defaultTonicMIDI
        ])
        let tonicMIDI: Int = defaults.integer(forKey: "tonicMIDI")
            
        // Pitch Direction
        let defaultPitchDirection: PitchDirection = PitchDirection.upward
        defaults.register(defaults: [
            "pitchDirection" : defaultPitchDirection.rawValue
        ])
        let pitchDirection: PitchDirection = PitchDirection(rawValue: defaults.integer(forKey: "pitchDirection")) ?? defaultPitchDirection

        // Keyboard Layout
        let defaultLayoutChoice: LayoutChoice = LayoutChoice.isomorphic
        defaults.register(defaults: [
            "layoutChoice" : defaultLayoutChoice.rawValue
        ])
        let layoutChoice: LayoutChoice = LayoutChoice(rawValue: defaults.string(forKey: "layoutChoice") ?? defaultLayoutChoice.rawValue) ?? defaultLayoutChoice
        
        // String Instruments Sub Layout
        let defaultStringsLayoutChoice: StringsLayoutChoice = StringsLayoutChoice.guitar
        defaults.register(defaults: [
            "stringsLayoutChoice" : defaultStringsLayoutChoice.rawValue
        ])
        let stringsLayoutChoice: StringsLayoutChoice = StringsLayoutChoice(rawValue: defaults.string(forKey: "stringsLayoutChoice") ?? defaultStringsLayoutChoice.rawValue) ?? defaultStringsLayoutChoice

        // Show Tonic Picker
        defaults.register(defaults: [
            "showTonicPicker" : false
        ])
        showTonicPicker = defaults.bool(forKey: "showTonicPicker")

        // Show Tonic Picker
        defaults.register(defaults: [
            "showTonicPicker" : false
        ])
        showTonicPicker = defaults.bool(forKey: "showTonicPicker")

        // Create the two conductors: one for the tonic picker and one for the primary keyboard
        _tonicConductor = StateObject(wrappedValue: ViewConductor(
            tonicMIDI: tonicMIDI,
            pitchDirection: pitchDirection,
            layoutChoice: .tonic,
            latching: true
        ))

        _viewConductor = StateObject(wrappedValue: ViewConductor(
            tonicMIDI: tonicMIDI,
            pitchDirection: pitchDirection,
            layoutChoice: layoutChoice,
            stringsLayoutChoice: stringsLayoutChoice
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
                        HeaderView(viewConductor: viewConductor, tonicConductor: tonicConductor, showTonicPicker: $showTonicPicker)
                            .frame(height: settingsHeight)
                        Spacer()
                    }
                    // Tonic Picker & Keyboard
                    VStack {
                        // Tonic Picker
                        if showTonicPicker {
                            Keyboard(conductor: tonicConductor) { pitch in
                                KeyboardKey(pitch: pitch,
                                            conductor: tonicConductor)
                                .aspectRatio(1.0, contentMode: .fit)
                            }
                            .aspectRatio(13.0, contentMode: .fit)
                            .padding(7.0)
                            .background {
                                RoundedRectangle(cornerRadius: 7.0)
                                    .fill(Color(tonicConductor.backgroundColor))
                            }                                
                            .transition(.scale(.leastNonzeroMagnitude, anchor: .top))
                        }
                        // Keyboard
                        Keyboard(conductor: viewConductor) { pitch in
                            KeyboardKey(pitch: pitch,
                                        conductor: viewConductor)
                        }
                        .ignoresSafeArea(edges:.horizontal)
                    }
                    .frame(height: .infinity)
                    .padding([.top, .bottom], settingsHeight + 5.0)
                    // Footer
                    VStack {
                        Spacer()
                        FooterView(viewConductor: viewConductor)
                            .frame(height: settingsHeight)
                    }
                    
                }
            }
            .statusBarHidden(true)
            .background(.black)
            .onChange(of: tonicConductor.tonicMIDI) {
                viewConductor.tonicMIDI = tonicConductor.tonicMIDI
                tonicConductor.externallyActivatedPitches.removeAll()
                defaults.set(tonicConductor.tonicMIDI, forKey: "tonicMIDI")
            }
            .onChange(of: tonicConductor.pitchDirection) {
                viewConductor.pitchDirection = tonicConductor.pitchDirection
                viewConductor.tonicMIDI = tonicConductor.tonicMIDI
                defaults.set(tonicConductor.pitchDirection.rawValue, forKey: "pitchDirection")
            }
            .onChange(of: viewConductor.layoutChoice) {
                defaults.set(viewConductor.layoutChoice.rawValue, forKey: "layoutChoice")
            }
            .onChange(of: viewConductor.stringsLayoutChoice) {
                defaults.set(viewConductor.stringsLayoutChoice.rawValue, forKey: "stringsLayoutChoice")
            }
            .onChange(of: showTonicPicker) {
                defaults.set(showTonicPicker, forKey: "showTonicPicker")
            }
        }
        .preferredColorScheme(.dark)
    }
}
