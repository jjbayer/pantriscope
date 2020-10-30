//
//  FocusTextField.swift
//  pantry
//
//  Created by Joris on 30.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//
import UIKit
import SwiftUI


// Copied from here: https://stackoverflow.com/questions/56507839/swiftui-how-to-make-textfield-become-first-responder
struct FocusTextField: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        var didBecomeFirstResponder = false

        init(text: Binding<String>) {
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

    }

    @Binding var text: String
    var isFirstResponder: Bool = false

    func makeUIView(context: UIViewRepresentableContext<FocusTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        return textField
    }

    func makeCoordinator() -> FocusTextField.Coordinator {
        return Coordinator(text: $text)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<FocusTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}


struct FocusTextField_Previews: PreviewProvider {

    struct Preview: View {
        @State var text: String = ""

        var body: some View {
            FocusTextField(text: $text, isFirstResponder: true)
                .frame(maxHeight: 100).border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/).padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
