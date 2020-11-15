//
//  PickDateButton.swift
//  pantry
//
//  Created by Joris on 11.11.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct PickDateButton: View {

    @Binding var selection: Date
    @State private var showDatePicker = false

    var body: some View {
        ExpiryDateOptionsButton(
            icon: "calendar",
            size: 50,
            color: App.Colors.secondary
        ) {

        }
        .fullScreenCover(isPresented: $showDatePicker) {
            DatePicker("", selection: $selection, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
        }
    }
}

struct PickDateButton_Previews: PreviewProvider {
    static var previews: some View {
        PickDateButton(selection: .constant(Date()))
    }
}
