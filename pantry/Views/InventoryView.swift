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

            if products.isEmpty {
                Text("No items in inventory.")
            } else {
                List {
                    ForEach(products) { product in
                        HStack {

                            self.photo(product)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 92, height: 92)
                                .clipped()

                            VStack {
                                HStack {
                                    Spacer()
                                }
                                Text(self.expiryText(product))
                            }

                            Spacer()

                            self.archiveButton(product, newState: "consumed", successMessage: "Product consumed.", icon: "checkmark.circle")
                            .foregroundColor(Color.green)

                            self.archiveButton(product, newState: "discarded", successMessage: "Product discarded.", icon: "trash.circle")
                            .foregroundColor(Color.red)
                        }
                        .buttonStyle(BorderlessButtonStyle()) // Else, entire list item becomes button

                    }
                }

                Spacer()
            }
        }
        .onDisappear {
            statusMessage.clear()
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

    private func archiveButton(_ product: Product, newState: String, successMessage: String, icon: String) -> some View {
        return Button(action: {
            product.state = newState
            self.save(successMessage: successMessage, undoAction: { self.restore(product) } )
        }) {
            Image(systemName: icon)

        }
        .frame(minWidth: 64, maxHeight: .infinity)
    }

    private func restore(_ product: Product) {
        product.state = "available"
        save(successMessage: "Product restored.")
    }

    private func save(successMessage: String, undoAction: StatusMessage.UndoAction? = nil) {
        do {
            try self.managedObjectContext.save()
            self.statusMessage.info(successMessage, undoAction: undoAction)
        } catch {
            self.statusMessage.error(error.localizedDescription)
        }
    }



}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
