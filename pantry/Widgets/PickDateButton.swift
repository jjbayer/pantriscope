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
    @Binding var hasDate: Bool
    
    @State private var showDatePicker = false

    var body: some View {
        VStack {
            ExpiryDateOptionsButton(
                icon: "calendar",
                size: 50,
                color: App.Colors.secondary
            ) {
                showDatePicker = true
            }
            .fullScreenCover(isPresented: $showDatePicker) {
                DatePicker("", selection: $selection, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
            }
        }
        .onChange(of: selection, perform: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                hasDate = true
                showDatePicker = false
            }
        })
    }
}

struct PickDateButton_Previews: PreviewProvider {
    static var previews: some View {
        PickDateButton(selection: .constant(Date()), hasDate: .constant(true))
    }
}
