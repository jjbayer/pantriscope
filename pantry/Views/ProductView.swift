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
    @Binding var statusMessage: StatusMessage

    @State private var productState: String
    @State private var expiryDate: Date

    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {

        StatusMessageView(statusMessage: $statusMessage)

        Form {

            Button(action: { detail = nil }) { HStack { Image(systemName: "chevron.backward"); Text("Back") } }

            Section {
                if let photoData = product.photo {
                    if let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    }
                }
                Text(product.addedStringLong)
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
                Button(action: {
                    print("Deleting...")
                    managedObjectContext.delete(product)
                    if let _ = try? managedObjectContext.save() {
                        detail = nil
                        statusMessage.info("Product deleted.")
                    } else {
                        statusMessage.error("Product could not be deleted.")
                    }
                }) {
                    Text("Delete forever").foregroundColor(App.Colors.error)
                }
                Button(action: {
                    print("Saving...")
                    product.expiryDate = expiryDate
                    product.state = productState
                    if let _ = try? managedObjectContext.save() {
                        detail = nil
                        statusMessage.info("Product saved.")
                    } else {
                        statusMessage.error("Product could not be saved.")
                    }
                }) {
                    Text("Save").foregroundColor(App.Colors.success)
                }


            }
        }
    }
}

extension ProductView {
    // init calling default constructor must be in extension, see https://docs.swift.org/swift-book/LanguageGuide/Initialization.html
    init(product: Product, detail: Binding<Product?>, statusMessage: Binding<StatusMessage>) {
        let productState = product.state ?? "available"
        let expiryDate = product.expiryDate ?? Date()

        self.init(product: product, detail: detail, statusMessage: statusMessage, productState: productState, expiryDate: expiryDate)
    }
}

struct ProductView_Previews: PreviewProvider {

    static var previews: some View {

        let product = Product()
        product.photo = UIImage(systemName: "image")?.pngData()
        product.state = "available"
        product.dateAdded = DateFormatter().date(from: "2020-09-31")
        product.expiryDate = DateFormatter().date(from: "2020-10-31")

        return ProductView(product: product, detail: .constant(nil), statusMessage: .constant(StatusMessage()))
    }
}
