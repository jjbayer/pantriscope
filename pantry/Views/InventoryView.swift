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

    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var statusMessage: StatusMessage

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
            Text("Inventory").font(.title)
            StatusMessageView()
            List {
                ForEach(products) { product in
                    HStack {

                        self.photo(product)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64, height: 64)

                        VStack {
                            HStack {
                                Spacer()
                            }
                            Text(self.expiryText(product))
                        }

                        Spacer()

                        Button(action: {
                            product.state = "consumed"
                            do {
                                try self.managedObjectContext.save()
                                self.statusMessage.message = "Product consumed."
                            } catch {
                                self.statusMessage.message = error.localizedDescription
                            }
                        }) {
                            Image(systemName: "checkmark.circle").imageScale(.large)
                        }
                        .foregroundColor(Color.green)

                        Button(action: {
                            product.state = "discarded"
                            do {
                                try self.managedObjectContext.save()
                                self.statusMessage.message = "Product discarded."
                            } catch {
                                self.statusMessage.message = error.localizedDescription
                            }
                        }) {
                            Image(systemName: "trash.circle").font(.largeTitle)
                        }
                        .foregroundColor(Color.red)


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
