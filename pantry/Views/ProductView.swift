//
//  ProductView.swift
//  pantry
//
//  Created by Joris on 20.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ProductView: View {

    var product: Product
    @Binding var detail: Product?
//
    @State private var productState = "available"
    @State private var expiryDate = Date()

//    init(product: Product, detail: Product?) {
//        self.product = product
//        self.detail = detail
//        productState = product.state ?? "available"
//        expiryDate = product.expiryDate ?? Date()
//    }

    var body: some View {

        Form {

            Section {
                Button(action: { detail = nil }) { Text("Back") }
            }

            Section {
                if let photoData = product.photo {
                    if let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    }
                }
                Text(product.addedStringLong)
//                Text("Detected text: \(product.detectedText ?? "")")
            }

            Section(header: Text("Edit")) {
                Picker("state", selection: $productState) {
                    Text("available").tag("available")
                    Text("discarded").tag("discarded")
                    Text("consumed").tag("consumed")
                }
                DatePicker("expiry date", selection: $expiryDate, displayedComponents: .date)
            }

            Section {
                Button(action: {}) {
                    Text("Save")
                }
            }
        }
    }
}

struct ProductView_Previews: PreviewProvider {

    static var previews: some View {

        let product = Product()
        product.photo = UIImage(systemName: "image")?.pngData()
        product.state = "available"
        product.dateAdded = DateFormatter().date(from: "2020-09-31")
        product.expiryDate = DateFormatter().date(from: "2020-10-31")

        return ProductView(product: product, detail: .constant(nil))
    }
}
