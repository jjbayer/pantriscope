//
//  InventoryView.swift
//  pantry
//
//  Created by Joris on 29.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct InventoryView: View {


    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var statusMessage = StatusMessage()

    @State private var searchString = ""

    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "expiryDate", ascending: true)
        ],
        predicate: NSPredicate(format: "state like 'available'")
    )
    var products: FetchedResults<Product>

    let currentDate = Date()

    var body: some View {

        VStack {

            StatusMessageView(statusMessage: $statusMessage)

            Text("Inventory").font(.title).padding()

            if products.isEmpty {
                Text("No items in inventory.")
            } else {

                ScrollView {

                    TextField("Search", text: $searchString)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    ForEach(products.filter {
                        searchString.isEmpty || $0.detectedText?.lowercased().contains(searchString) ?? false
                    }) { product in
                        ProductCard(product: product, statusMessage: $statusMessage)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
                }
                Spacer()
            }
        }
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
