//
//  SwiftUIView.swift
//  pantry
//
//  Created by Joris on 09.11.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ExpiryDateOptions: View {

    @Binding var expiryDate: Date
    @Binding var dateWasSelected: Bool
    var saveAction: (Bool) -> ()

    @State private var productHasExpiryDate = true

    var body: some View {
        VStack {
            ExpiryDateOptionsSection {
                HStack {
                    Toggle("has expiry date", isOn: $productHasExpiryDate)


                    Text("expiry date")

                    Spacer()

                    DatePicker(
                        "expiry date",
                        selection: $expiryDate,
                        displayedComponents: .date
                    )
                    .onChange(of: expiryDate, perform: { value in
                        dateWasSelected = true
                    })
                    .opacity(productHasExpiryDate ? 1 : 0)
                    .disabled(!productHasExpiryDate)
                }
                .labelsHidden()
                .padding(5)
            }
            .background(Color.white)
            .cornerRadius(10)

            ExpiryDateOptionsSection {
                Button("Save") { saveAction(productHasExpiryDate) }
                    .disabled(!canSave)
            }
            .foregroundColor(Color.white)
            .background(App.Colors.primary)
            .cornerRadius(10)
            .opacity(canSave ? 1 : 0)
        }
    }

    private var canSave: Bool {
        return dateWasSelected || !productHasExpiryDate
    }
}


struct ExpiryDateOptionsSection<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {

        content
            .frame(maxWidth: .infinity, minHeight: 50)

    }
}

struct ExpiryDateOptionsButton: View {
    let icon: String
    let size: CGFloat
    let color: Color
    let action: () -> ()

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
        }
        .foregroundColor(.white)
        .frame(minWidth: size, minHeight: size)
        .background(color)
        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        .font(.title)
        .frame(maxWidth: .infinity)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ExpiryDateOptions(
            expiryDate: .constant(Date()),
            dateWasSelected: .constant(false),
            saveAction: { _ in ()}
        )
            .environment(\.locale, .init(identifier: "de"))
    }
}
