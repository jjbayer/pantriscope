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
    @State private var showDatePicker = false

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Toggle("has expiry date", isOn: $productHasExpiryDate)


                    Text("expiry date")

                    Spacer()

                    Text("\(formattedDate)")
                    .foregroundColor(App.Colors.primary)
                    .onTapGesture {
                        showDatePicker = true
                    }
                    .fullScreenCover(isPresented: $showDatePicker) {
                        DatePicker(
                            "expiry date",
                            selection: $expiryDate,
                            displayedComponents: .date
                        )
                        .onChange(of: expiryDate, perform: { _ in
                                dateWasSelected = true
                                showDatePicker = false
                        })
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                    }

                    .opacity(productHasExpiryDate ? 1 : 0)
                    .disabled(!productHasExpiryDate)
                }
                .labelsHidden()
                .padding(10)

            }
            .background(Color.white)
            .cornerRadius(10)

            Button(action: {saveAction(productHasExpiryDate)}, label: {
                Text("Save")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(Color.white)
                    .background(App.Colors.primary)
                    .cornerRadius(10)

            })
            .disabled(!canSave)
            .opacity(canSave ? 1 : 0)
        }
    }

    private var canSave: Bool {
        return dateWasSelected || !productHasExpiryDate
    }

    private var formattedDate: String {

        if !dateWasSelected {
            return NSLocalizedString("Choose", comment: "")
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none

        return formatter.string(from: self.expiryDate)
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
