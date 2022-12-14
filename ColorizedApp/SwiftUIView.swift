//
//  SwiftUIView.swift
//  ColorizedApp
//
//  Created by albik on 25.11.2022.
//

import SwiftUI

struct SwiftUIView: View {

    private enum textField {
        case red
        case green
        case blue
    }
    
    @State private var redSlider = Double.random(in: 1...255).rounded()
    @State private var greenSlider = Double.random(in: 1...255).rounded()
    @State private var blueSlider = Double.random(in: 1...255).rounded()
    
    @State private var showAlert = false
    
    @FocusState private var isInputActive: Bool
    @FocusState private var focusedField: textField?
    
    var body: some View {
        ZStack {
            Color(.white)
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 200)
                    .foregroundColor(Color(
                        red: redSlider / 255,
                        green: greenSlider / 255,
                        blue: blueSlider / 255))
                    .padding(.bottom, 32.0)
                VStack{
                    ColorSeting(colorValue: $redSlider, color: .red)
                        .focused($focusedField, equals: .red)
                    ColorSeting(colorValue: $greenSlider, color: .green)
                        .focused($focusedField, equals: .green)
                    ColorSeting(colorValue: $blueSlider, color: .blue)
                        .focused($focusedField, equals: .blue)
                        .alert("Incorrect Format", isPresented: $showAlert, actions: {}) {
                            Text("Please enter number from 0 to 255")
                        }
                }
                .focused($isInputActive)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button(action: nextField) {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                        Spacer()
                        Button("Done") {
                            isInputActive = false
                        }
                    }
                }
                Spacer()
            }.padding()
        }.onTapGesture {
            isInputActive = false
        }
    }
    private func nextField() {
        if focusedField == .none {
            focusedField = .red
        } else if focusedField == .red {
            focusedField = .green
        } else if focusedField == .green {
            focusedField = .blue
        } else if focusedField == .blue {
            focusedField = .red
        }
    }
}


struct SwiftUIViewPreviews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

struct ColorSeting: View {
    
    @Binding var colorValue: Double
    @State var showAlert = false
    @FocusState private var focusState: Bool
    
    let color: Color
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimum = 1
        formatter.maximum = 255
        
        return formatter
    }()
    
    var body: some View {
        HStack {
            Text("\(lround(colorValue))")
                .frame(width: 45, alignment: .leading)
            Slider(value: $colorValue, in: 1...255, step: 1)
                .accentColor(color)
            TextField("", value: $colorValue, formatter: formatter, prompt: Text("Please enter a number from 1 to 255"))
                .textFieldStyle(.roundedBorder)
                .frame(width: 45)
                .keyboardType(.decimalPad)
                .focused($focusState)
                .alert("Incorrect Format", isPresented: $showAlert, actions: {}) {
                    Text("Please enter number from 0 to 255")
                }
                .onSubmit {
                    if colorValue is Int, (0...255).contains(colorValue) {
                        return
                    } else {
                        showAlert.toggle()
                        colorValue = 0
                    }
                }
        }
    }
}
