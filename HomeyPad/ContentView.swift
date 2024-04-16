import SwiftUI

struct ContentView: View {
    let defaults = UserDefaults.standard
    @State var showTonicPicker: Bool = false
    @StateObject private var tonicConductor: ViewConductor
    @StateObject private var viewConductor: ViewConductor

    init() {
        let defaultTonicMIDI: Int = 60
        defaults.register(defaults: [
            "tonicMIDI" : defaultTonicMIDI
        ])
        let tonicMIDI: Int = defaults.integer(forKey: "tonicMIDI")
            
        let defaultLayoutChoice: LayoutChoice = LayoutChoice.isomorphic
        defaults.register(defaults: [
            "layoutChoice" : defaultLayoutChoice.rawValue
        ])
        let layoutChoice: LayoutChoice = LayoutChoice(rawValue: defaults.string(forKey: "layoutChoice") ?? defaultLayoutChoice.rawValue) ?? defaultLayoutChoice
        
        let defaultStringsLayoutChoice: StringsLayoutChoice = StringsLayoutChoice.guitar
        defaults.register(defaults: [
            "stringsLayoutChoice" : defaultStringsLayoutChoice.rawValue
        ])
        let stringsLayoutChoice: StringsLayoutChoice = StringsLayoutChoice(rawValue: defaults.string(forKey: "stringsLayoutChoice") ?? defaultStringsLayoutChoice.rawValue) ?? defaultStringsLayoutChoice

        _tonicConductor = StateObject(wrappedValue: ViewConductor(
            layoutChoice: .tonic,
            latching: true,
            tonicMIDI: tonicMIDI
        ))

        _viewConductor = StateObject(wrappedValue: ViewConductor(
            layoutChoice: layoutChoice,
            stringsLayoutChoice: stringsLayoutChoice,
            tonicMIDI: tonicMIDI
        ))
    }
    
    var body: some View {
        let settingsHeight = 30.0
        GeometryReader { proxy in
            ZStack {
                Color.black
                ZStack() {
                    VStack {
                        HeaderView(viewConductor: viewConductor, tonicConductor: tonicConductor, showTonicPicker: $showTonicPicker)
                            .frame(height: settingsHeight)
                        Spacer()
                    }
                    VStack {
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
                        Keyboard(conductor: viewConductor) { pitch in
                            KeyboardKey(pitch: pitch,
                                        conductor: viewConductor)
                        }
                        .ignoresSafeArea(edges:.horizontal)
                    }
                    .frame(height: .infinity)
                    .padding([.top, .bottom], settingsHeight + 5.0)
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
            }
            .onChange(of: viewConductor.layoutChoice) {
                defaults.set(viewConductor.layoutChoice.rawValue, forKey: "layoutChoice")
            }
            .onChange(of: viewConductor.stringsLayoutChoice) {
                defaults.set(viewConductor.stringsLayoutChoice.rawValue, forKey: "stringsLayoutChoice")
            }
        }
        .preferredColorScheme(.dark)
    }
}
