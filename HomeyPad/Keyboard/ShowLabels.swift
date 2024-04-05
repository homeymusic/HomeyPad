import SwiftUI

public class ShowLabels {
    var layout: LayoutChoice
    var intervalLabels: [IntervalLabelChoice: Bool]
    var noteLabels: [NoteLabelChoice: Bool]
    
    init(layout: LayoutChoice, intervalLabels: [IntervalLabelChoice: Bool], noteLabels: [NoteLabelChoice: Bool]) {
        self.layout = layout
        self.intervalLabels = intervalLabels
        self.noteLabels = noteLabels
    }
    
    var allIntervalKeys: [IntervalLabelChoice] {
        return Array(intervalLabels.keys)
    }
    
    public func intervalBinding(for key: IntervalLabelChoice) -> Binding<Bool> {
        return Binding(
            get: {
                print("get here!")
                return self.intervalLabels[key] ?? false
            },
            set: {
                print("set here! \($0)")
                self.intervalLabels[key] = $0
                print("self.intervalLabels[key]: \(self.intervalLabels[key]!)")
            }
        )
    }
}

