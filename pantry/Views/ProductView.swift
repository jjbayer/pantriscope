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
    @State private var showDeletionConfirmation = false

    #if DEBUG
    @State private var dateAdded: Date
    #endif

    @Environment(\.presentationMode) var presentationMode
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

                #if DEBUG
                if let inventoryID = product.inventory?.id {
                    Text("Inventory ID: \(inventoryID)")
                }
                if let productID = product.id {
                    Text("Product ID: \(productID)")
                }
                if let detectedText = product.detectedText {
                    Text("Detected text:\n\(detectedText)")
                }
                #endif

                Text(product.addedStringLong)
            }

            Section(header: Text("Edit")) {
                Picker("state", selection: $productState) {
                    Text("available").tag("available")
                    Text("discarded").tag("discarded")
                    Text("consumed").tag("consumed")
                }.pickerStyle(SegmentedPickerStyle())

                #if DEBUG
                DatePicker("date added", selection: $dateAdded, displayedComponents: .date)
                #endif

                Toggle("has expiry date", isOn: $hasExpiryDate)

                if hasExpiryDate {
                    let label = NSLocalizedString("expiry date", comment: "")
                    DatePicker(label, selection: $expiryDate, displayedComponents: .date)
                }
            }

            #if DEBUG
            Section(header: Text("Notifications")) {
                if let reminders = product.reminder?.allObjects as? [Reminder] {
                    ForEach(reminders, id: \.id) { reminder in
                        Text("\(reminder.timeBeforeExpiry)")
                    }
                }

                Button(action: { Notifier.instance.scheduleReminder(product, -1)}) {
                    HStack {
                        Image(systemName: "paperplane")
                        Text("Send test notification")
                    }
                }.foregroundColor(App.Colors.note)
            }
            #endif

            Section {

                Button(action: {
                    showDeletionConfirmation = true
                }) {
                    Text("Delete").foregroundColor(App.Colors.error)
                }
                .actionSheet(isPresented: $showDeletionConfirmation) {
                    ActionSheet(title: Text("Delete product"), buttons: [
                        .cancel(Text("Cancel")),
                        .destructive(Text("Delete forever")) {
                            managedObjectContext.delete(product)
                            if let _ = try? managedObjectContext.save() {

                                // Back to list view
                                presentationMode.wrappedValue.dismiss()

                                statusMessage.success(
                                    NSLocalizedString("Product deleted.", comment: ""))
                            } else {
                                statusMessage.error(
                                    NSLocalizedString("Product could not be deleted.", comment: ""))
                            }
                        }
                    ])
                }
                .frame(maxWidth: .infinity, alignment: .center)

                Button(action: {

                    #if DEBUG
                    product.dateAdded = dateAdded
                    #endif

                    if hasExpiryDate {
                        product.expiryDate = expiryDate
                    } else {
                        product.expiryDate = nil
                    }
                    product.state = productState
                    if let _ = try? managedObjectContext.save() {

                        // Back to list view
                        presentationMode.wrappedValue.dismiss()

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
        #if DEBUG
        let dateAdded = product.dateAdded ?? Date()
        self.init(product: product, statusMessage: statusMessage, productState: productState, hasExpiryDate: hasExpiryDate, expiryDate: expiryDate, dateAdded: dateAdded)
        #else
        self.init(product: product, statusMessage: statusMessage, productState: productState, hasExpiryDate: hasExpiryDate, expiryDate: expiryDate)
        #endif


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
