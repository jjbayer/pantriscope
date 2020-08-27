//
//  CameraView.swift
//  pantry
//
//  Created by Joris on 21.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ScanExpiryDate: View {


    @ObservedObject private var product = Product()

    var body: some View {
        NavigationView {
        ZStack {
//            CameraView()
            VStack {
                Text("Scan Expiry Date")
                    .font(.title)
                Spacer()

                if product.hasExpiryDate {
                    DatePicker("", selection: $product.expiryDate, displayedComponents: .date)
                    .labelsHidden()
                }

                Toggle(isOn: $product.hasExpiryDate) {
                    Text("product has expiry date")
                }
                .padding()

                NavigationLink(destination: Inventory(product: product)) {
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

}

struct ScanExpiryDate_Previews: PreviewProvider {
    static var previews: some View {
        ScanExpiryDate()
    }
}
