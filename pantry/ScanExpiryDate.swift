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
    @State private var productHasExpiryDate = true

    var body: some View {
        ZStack {
//            CameraView()
            VStack {
                Text("Scan Expiry Date")
                    .font(.title)
                Spacer()

                if productHasExpiryDate {
                    DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
                }

                Toggle(isOn: $productHasExpiryDate) {
                    Text("product has expiry date")
                }
                .padding()

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

}

struct ScanExpiryDate_Previews: PreviewProvider {
    static var previews: some View {
        ScanExpiryDate()
    }
}
