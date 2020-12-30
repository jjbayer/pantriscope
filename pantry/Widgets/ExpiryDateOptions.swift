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
    @Binding var dateWasDetected: Bool
    @Binding var dateWasSetManually: Bool
    @Binding var showDatePicker: Bool

    var saveAction: (Bool) -> ()

    @State private var productHasExpiryDate = true

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Toggle("has expiry date", isOn: $productHasExpiryDate)


                    Text("expiry date")

                    Spacer()


                    Button(action:{ showDatePicker = true }) {
                        Text("\(self.formattedDate)")
                    }

                    .sheet(isPresented: $showDatePicker) {
                        CustomDatePicker(
                            isPresented: $showDatePicker,
                            date: $expiryDate,
                            dateWasSelected: $dateWasSetManually
                        )
                    }
                    .foregroundColor(App.Colors.primary)
                    

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

    private var dateWasSet: Bool {
        return dateWasDetected || dateWasSetManually
    }

    private var canSave: Bool {
        return dateWasSet || !productHasExpiryDate
    }

    private var formattedDate: String {

        if !dateWasSet {
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
            dateWasDetected: .constant(false),
            dateWasSetManually: .constant(false),
            showDatePicker: .constant(false),
            saveAction: { _ in ()}
        )
            .environment(\.locale, .init(identifier: "de"))
    }
}
