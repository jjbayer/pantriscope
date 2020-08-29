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

    var body: some View {

        List {
            ForEach(products) { product in
                if product.expiryDate != nil {
                    Text("\(product.expiryDate!)")
                } else {
                    Text("no expiry date")
                }
            }
        }

    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
