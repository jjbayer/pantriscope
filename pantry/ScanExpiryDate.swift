//
//  CameraView.swift
//  pantry
//
//  Created by Joris on 21.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ScanExpiryDate: View {

    @State var date = Date()

    var body: some View {
        VStack {
            Text("Scan Expiry Date")
            CameraView()
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
            NavigationLink(destination: ScanExpiryDate()) {
                HStack {
                    Image(systemName: "leaf")
                    Text("Add Product")
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(20)
            .padding(.horizontal)

        }
    }

}
