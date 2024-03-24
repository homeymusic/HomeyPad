//
//  RootStepperView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 3/24/24.
//

import SwiftUI
import Tonic

struct RootStepperView: View {
    @StateObject var viewConductor: ViewConductor
    
    var body: some View {
        Stepper("Root: \(viewConductor.root.description)",
                onIncrement: {
            let allSharpNotes = (0...11).map { Note(pitch: Pitch(intValue: $0)).noteClass }
            var index = allSharpNotes.firstIndex(of: viewConductor.root.canonicalNote.noteClass) ?? 0
            index += 1
            if index > 11 { index = 0}
            if index < 0 { index = 1}
            viewConductor.rootIndex = index
            viewConductor.root = allSharpNotes[index]
        },
                onDecrement: {
            let allSharpNotes = (0...11).map { Note(pitch: Pitch(intValue: $0)).noteClass }
            var index = allSharpNotes.firstIndex(of: viewConductor.root.canonicalNote.noteClass) ?? 0
            index -= 1
            if index > 11 { index = 0}
            if index < 0 { index = 1}
            viewConductor.rootIndex = index
            viewConductor.root = allSharpNotes[index]
        })
    }
}
