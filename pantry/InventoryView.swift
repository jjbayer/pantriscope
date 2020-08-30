//
//  InventoryView.swift
//  pantry
//
//  Created by Joris on 29.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

extension Product: Identifiable {}

struct InventoryView: View {

    @FetchRequest(entity: Product.entity(), sortDescriptors: [])
    var products: FetchedResults<Product>

    let currentDate = Date()

    var body: some View {
        List {
            ForEach(products) { product in
                HStack {

                    self.photo(product)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 64)

                    VStack {
                        Text("expiry date:").font(.headline)
                        Text(self.expiryText(product))
                    }

                }

            }
        }
    }

    private func photo(_ product: Product) -> Image {
        if let photoData = product.photo {
            if let uiImage = UIImage(data: photoData) {

                return Image(uiImage: uiImage)
            }
        }

        return Image(systemName: "photo")
    }

    private func expiryText(_ product: Product) -> String {
        if let expiryDate = product.expiryDate {

            let fmt = DateFormatter()
            fmt.dateStyle = .medium

            return fmt.string(from: expiryDate)
        } else {

            return "no expiry date"
        }
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
