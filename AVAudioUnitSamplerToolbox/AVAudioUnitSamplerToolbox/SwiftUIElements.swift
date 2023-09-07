import Foundation
import SwiftUI
import Keyboard
import Tonic
import Controls
import AVFoundation

struct SwiftUIKeyboard: View {
    var octaveCount: Int
    var tonicPitchClass: Int = 0
    var noteOn: (Pitch, CGPoint) -> Void = { _, _ in }
    var noteOff: (Pitch)->Void
    
    var body: some View {
        Keyboard(layout: .dualistic(octaveCount: octaveCount, tonicPitchClass: tonicPitchClass),
                 noteOn: noteOn, noteOff: noteOff){ pitch, isActivated in
            SwiftUIKeyboardKey(pitch: pitch,
                               tonicPitchClass: tonicPitchClass,
                               isActivated: isActivated)
        }.cornerRadius(5)
    }
}

struct SwiftUIKeyboardKey: View {
    @State var MIDIKeyPressed = [Bool](repeating: false, count: 128)
    var pitch : Pitch
    var tonicPitchClass : Int
    var isActivated : Bool
    
    var body: some View {
        VStack{
            IntervallicKey(pitch: pitch,
                           tonicPitchClass: tonicPitchClass,
                           isActivated: isActivated,
                           tonicColor: Color(red: 102 / 255, green: 68 / 255, blue: 51 / 255),
                           perfectColor: Color(red: 243 / 255, green: 221 / 255, blue: 171 / 255),
                           majorColor: Color(red: 255 / 255, green: 176 / 255, blue: 0 / 255),
                           minorColor: Color(red: 138 / 255, green: 197 / 255, blue: 320 / 255),
                           tritoneColor: Color(red: 255 / 255, green: 85 / 255, blue: 0 / 255),
                           keyColor: Color(red: 102 / 255, green: 68 / 255, blue: 51 / 255),
                           tonicKeyColor: Color(red: 243 / 255, green: 221 / 255, blue: 171 / 255),
                           flatTop: true,
                           isActivatedExternally: MIDIKeyPressed[pitch.intValue])
        }.onReceive(NotificationCenter.default.publisher(for: .MIDIKey), perform: { obj in
            if let userInfo = obj.userInfo, let info = userInfo["info"] as? UInt8, let val = userInfo["bool"] as? Bool {
                self.MIDIKeyPressed[Int(info)] = val
            }
        })
    }
}

///Knobs
struct SwiftUIRack: View {
    @State var knob1: Binding<Float>
    @State var knob2: Binding<Float>
    @State var knob3: Binding<Float>
    @State var knob4: Binding<Float>
    @State var knob5: Binding<Float>
    @State var knob6: Binding<Float>
    @State var knob7: Binding<Float>
    var updateMIDIFilter: (AUValue, Int)->Void = { _, _ in }
    
    var body: some View {
        HStack {
            Spacer()
            SwiftUIKnob(updateMIDI1: updateMIDIFilter, knobNumber: 1 ,value: knob1, range: 0...100, title: "Reverb", places: "0").frame(maxWidth: 120, maxHeight: 120)
            Spacer()
            SwiftUIKnob(updateMIDI1: updateMIDIFilter, knobNumber: 2 ,value: knob2, range: 0...100, title: "Delay", places: "0").frame(maxWidth: 120, maxHeight: 120)
            Spacer()
            SwiftUIKnob(updateMIDI1: updateMIDIFilter, knobNumber: 3 ,value: knob3, range: 0...2, title: "Delay Time", places: "2")
                .frame(maxWidth: 120, maxHeight: 120)
            Spacer()
            SwiftUIKnob(updateMIDI1: updateMIDIFilter, knobNumber: 4 ,value: knob4, range: 0...127, title: "Filter", places: "0").frame(maxWidth: 120, maxHeight: 120)
            Group{
                Spacer()
                SwiftUIKnob(updateMIDI1: updateMIDIFilter, knobNumber: 5, value: knob5, range: 0...127, title: "Velocity", places: "0").frame(maxWidth: 120, maxHeight: 120)
                Spacer()
                SwiftUIKnob(updateMIDI1: updateMIDIFilter, knobNumber: 6, value: knob6, range: -12.0...12.0, title: "Volume", places: "2").frame(maxWidth: 120, maxHeight: 120)
                Spacer()
                SwiftUIKnob(updateMIDI1: updateMIDIFilter, knobNumber: 7, value: knob7, range: 1...7, title: "Octaves", places: "0").frame(maxWidth: 120, maxHeight: 120)
                Spacer()
            }
            
        }.padding(.bottom,17)
            .frame(maxWidth: 800, alignment: .center)
    }
}

public struct SwiftUIKnob: View {
    var updateMIDI1: (AUValue, Int)->Void = { _, _ in }
    @Binding var value: Float
    var range: ClosedRange<Float>
    var knobNumber = 0
    var title: String = ""
    @State var displayString: String = ""
    var places: String = "0"
    @State var isShowingValue = false
    var knobPreferredWidth: CGFloat = 100
    var knobBgColor = Color(hue: 0.5, saturation: 0.75, brightness: 0.5, opacity: 0.55)
    var knobBgCornerRadius: CGFloat = 1
    var knobLineCap: CGLineCap = .round
    var knobCircleWidth: CGFloat = 1
    var knobStrokeWidth: CGFloat = 1
    var knobRotationRange: CGFloat = 0.875
    var knobTrimMin: CGFloat = 1
    var knobTrimMax: CGFloat = 1
    var knobDragSensitivity: CGFloat = 0.0075
    var isNegative = false
    
    public init(updateMIDI1: @escaping (AUValue, Int)->Void = { _, _ in }, knobNumber: Int, value: Binding<Float>, range: ClosedRange<Float>, title: String, places: String) {
        self.knobNumber = knobNumber
        self._value = value
        self.updateMIDI1 = updateMIDI1
        self.range = range
        self.title = title
        self.displayString = title
        self.places = places
        knobPreferredWidth = 50
        knobBgCornerRadius = 3.0 * 0.25 * knobPreferredWidth
        knobCircleWidth = 0.7 * knobPreferredWidth
        knobStrokeWidth = 2 * knobPreferredWidth / 25
        knobTrimMin = (1 - knobRotationRange) / 2.0
        knobTrimMax = 1 - knobTrimMin
        if range.lowerBound != 0 {
            isNegative = true
        }
    }
    @State private var lastLocation: CGPoint = CGPoint(x: 0, y: 0)
    var rangeDegrees = 270.0
    
    public var body: some View {
        Control(value:Binding(
            get: { value },
            set: { (newValue) in
                if !isShowingValue && value != newValue {
                    isShowingValue = true
                }
                value = newValue
                updateMIDI1(value,knobNumber)
                
            }), in: range, geometry: .twoDimensionalDrag(xSensitivity: 0.5, ySensitivity: 0.5),
                onEnded: {
            isShowingValue = false
        }) { geo in
            //            GeometryReader { geometry in
            VStack {
                Text("\(isShowingValue ? "\(String(format: "%0.\(places)f", value ))" : title)").lineLimit(1)
                
                Image("knob1")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .rotationEffect(.degrees(320 * (isNegative ? Double((value - range.lowerBound) / (range.upperBound - range.lowerBound)) : Double(value / range.upperBound)) - 160))
                
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
        .onTapGesture(count: 2) {
            if knobNumber == 4 {//Filter
                value = 127
            }else{
                value = 0
            }
        }
    }
}
