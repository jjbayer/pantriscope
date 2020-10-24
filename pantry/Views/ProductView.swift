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
    @Binding var statusMessage: StatusMessage

    @State private var productState: String
    @State private var hasExpiryDate: Bool
    @State private var expiryDate: Date

    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var navigator: Navigator

    var body: some View {

        VStack {
            innerView
        }.navigationBarTitle(Text("Product details"), displayMode: .inline)
    }

    var innerView: some View {

        Form {

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
                }.pickerStyle(SegmentedPickerStyle())
                Toggle("has expiry date", isOn: $hasExpiryDate)
                if hasExpiryDate {
                    let label = NSLocalizedString("expiry date", comment: "")
                    DatePicker(label, selection: $expiryDate, displayedComponents: .date)
                }
            }

            #if DEBUG
            Section {
                Button(action: { Notifier.instance.scheduleReminder(product, 0)}) {
                    HStack {
                        Image(systemName: "paperplane")
                        Text("Send test notification")
                    }
                }.foregroundColor(App.Colors.note)
            }
            #endif

            Section {

                Button(action: {
                    print("Deleting...")
                    managedObjectContext.delete(product)
                    if let _ = try? managedObjectContext.save() {
                        navigator.productDetail = nil
                        statusMessage.success(
                            NSLocalizedString("Product deleted.", comment: ""))
                    } else {
                        statusMessage.error(
                            NSLocalizedString("Product could not be deleted.", comment: ""))
                    }
                }) {
                    Text("Delete forever").foregroundColor(App.Colors.error)
                }
                .frame(maxWidth: .infinity, alignment: .center)

                Button(action: {
                    print("Saving...")
                    if hasExpiryDate {
                        product.expiryDate = expiryDate
                    } else {
                        product.expiryDate = nil
                    }
                    product.state = productState
                    if let _ = try? managedObjectContext.save() {
                        navigator.productDetail = nil
                        statusMessage.success(
                            NSLocalizedString("Product saved.", comment: "")
                        )
                    } else {
                        statusMessage.error(
                            NSLocalizedString("Product could not be saved.", comment: "")
                        )
                    }
                }) {
                    Text("Save").foregroundColor(App.Colors.primary)
                }
                .frame(maxWidth: .infinity, alignment: .center)

            }
        }
    }
}

extension ProductView {
    // init calling default constructor must be in extension, see https://docs.swift.org/swift-book/LanguageGuide/Initialization.html
    init(product: Product, statusMessage: Binding<StatusMessage>) {
        let productState = product.state ?? "available"
        let expiryDate = product.expiryDate ?? Date()
        let hasExpiryDate = product.expiryDate != nil

        self.init(product: product, statusMessage: statusMessage, productState: productState, hasExpiryDate: hasExpiryDate, expiryDate: expiryDate)
    }
}

struct ProductView_Previews: PreviewProvider {

    static var previews: some View {

        let product = Product()
        product.photo = UIImage(systemName: "image")?.pngData()
        product.state = "available"
        product.dateAdded = DateFormatter().date(from: "2020-09-31")
        product.expiryDate = DateFormatter().date(from: "2020-10-31")

        return ProductView(product: product, statusMessage: .constant(StatusMessage()))
    }
}
