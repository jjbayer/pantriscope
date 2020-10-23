//
//  ArchivedProducts.swift
//  pantry
//
//  Created by Joris on 23.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ArchivedProducts: View {

    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "expiryDate", ascending: false)
        ],
        predicate: NSPredicate(format: "state != 'available'")
    )
    private var products: FetchedResults<Product>

    @State private var statusMessage = StatusMessage()

    var body: some View {
        VStack {

            StatusMessageView(statusMessage: $statusMessage)

            List {
                ForEach(products) { product in
                    NavigationLink(destination: ProductView(product: product, statusMessage: $statusMessage)) {
                        HStack {
                            ProductThumbnail(product: product)
                            Text(product.addedStringLong)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text("Archived products"))
    }
}

struct ArchivedProducts_Previews: PreviewProvider {
    static var previews: some View {
        ArchivedProducts()
    }
}
