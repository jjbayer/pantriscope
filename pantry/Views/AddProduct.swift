//
//  AddProduct.swift
//  pantry
//
//  Created by Joris on 12/30/20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct AddProduct: View {

    @State private var productState = "available"
    @State private var hasExpiryDate = true
    @State private var expiryDate = Date()
    @State private var showFileImporter = false

    @State private var imageData: Data? = nil

    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        NavigationView {
            Form {
                Section {
                    if let imageData = self.imageData {
                        if let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                        }
                    }

                    Button("Select image") {
                        showFileImporter = true
                    }
                }

                Section {

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

                Section {
                    Button(action: {

                        let product = Product(context: managedObjectContext)


                        product.id = UUID()

                        product.inventory = Inventory.defaultInventory(managedObjectContext)

                        product.photo = self.imageData

                        if hasExpiryDate {
                            product.expiryDate = expiryDate
                        } else {
                            product.expiryDate = nil
                        }
                        product.state = productState
                        if let _ = try? managedObjectContext.save() {


                        } else {

                            print("error")
                        }
                    }) {
                        Text("Save").foregroundColor(App.Colors.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }.fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.jpeg],
            allowsMultipleSelection: false
        ){ result in
            var url: [URL]
            do {
                try url = result.get()
            } catch {
//                            Logger().reportError(error: error)
                return
            }

            let imageURL = url[0]
            let _ = imageURL.startAccessingSecurityScopedResource()
            let data = FileManager.default.contents(atPath: imageURL.path)
            imageURL.stopAccessingSecurityScopedResource()
            self.imageData = data
        }
    }
    
}

struct AddProduct_Previews: PreviewProvider {
    static var previews: some View {
        AddProduct()
    }
}
