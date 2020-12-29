//
//  CustomDatePicker.swift
//  pantry
//
//  Created by Joris on 12/29/20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct CustomDatePicker: View {

    @Binding var isPresented: Bool

    @Binding var outputDate: Date

    @Binding var dateWasSelected: Bool

    @State private var inputDate: Date

    init(isPresented: Binding<Bool>, date: Binding<Date>, dateWasSelected: Binding<Bool>) {

        self._isPresented = isPresented
        self._outputDate = date
        self._dateWasSelected = dateWasSelected

        // Initialize with same value as output date:
        self._inputDate = State<Date>(initialValue: date.wrappedValue)
    }

    var body: some View {

        VStack {

            DatePicker(
                "expiry date",
                selection: $inputDate,
                displayedComponents: .date
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()



            Button(action: {
                dateWasSelected = true
                outputDate = inputDate
                isPresented = false
            }) {
                Text("Use this date").foregroundColor(App.Colors.primary)
            }
        }

    }

}

struct CustomDatePicker_Previews: PreviewProvider {

    struct Preview: View {

        @State private var show = true

        @State private var date = Date()

        @State private var isPresented = true

        var body: some View {
            NavigationView {
                NavigationLink(
                    destination: CustomDatePicker(
                        isPresented: $isPresented,
                        date: $date,
                        dateWasSelected: .constant(false))
                    , isActive: $isPresented)
                {
                        Text("\(date)")
                    }
            }
        }
    }


    static var previews: some View {
        Preview()
    }
}
