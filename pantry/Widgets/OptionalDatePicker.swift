//
//  CustomDatePicker.swift
//  pantry
//
//  Created by Joris on 03.11.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct CustomDatePicker: View {

    var initialLabel: Text
    var labelAfterPick: Text
    @Binding var selection: Date

    @State private var dateWasPicked = false
    @State private var showDatePicker = false

    var body: some View {
        HStack {

            self.label

            Spacer()

            Button(dateFormat) {
                showDatePicker = true
            }
            .fullScreenCover(isPresented: $showDatePicker) {
                DatePicker("", selection: $selection, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())

            }
        }
        .onChange(of: selection, perform: { value in
            dateWasPicked = true
            showDatePicker = false
        })
    }

    var label: Text {
        dateWasPicked ? labelAfterPick : initialLabel
    }

    var dateFormat: String {
        if dateWasPicked {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none

            return formatter.string(from: self.selection)
        }

        return NSLocalizedString("pick manually", comment: "")
    }
}

struct CustomDatePicker_Previews: PreviewProvider {

    struct Preview: View {
        @State private var date = Date()
        var body: some View {
            CustomDatePicker(
                initialLabel: Text("Detecting..."),
                labelAfterPick: Text("Expiry date"),
                selection: $date
            )
        }
    }

    static var previews: some View {
        Preview()
    }
}
