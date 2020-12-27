//
//  ArchivedProducts.swift
//  pantry
//
//  Created by Joris on 23.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ArchivedProducts: View {

    @Binding var statusMessage: StatusMessage

    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "expiryDate", ascending: false)
        ],
        predicate: NSPredicate(format: "state != 'available'")
    )
    private var products: FetchedResults<Product>

    var body: some View {

        List {
            ForEach(products) { product in
                NavigationLink(destination: ProductView(product: product, statusMessage: $statusMessage)) {
                    HStack {
                        ProductThumbnail(imageData: product.photo)
                        Text(product.addedStringLong)
                    }
                }
                .isDetailLink(true)
            }
            .listRowInsets(.none)
        }
        .navigationBarTitle(Text("Archived products"), displayMode: .inline)
    }
}

struct ArchivedProducts_Previews: PreviewProvider {
    static var previews: some View {
        ArchivedProducts(statusMessage: .constant(StatusMessage()))
    }
}
