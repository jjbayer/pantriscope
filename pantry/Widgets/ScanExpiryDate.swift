//
//  ScanExpiryDate.swift
//  pantry
//
//  Created by Joris on 21.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI
import AVFoundation



struct ScanExpiryDate: View {

    // I would prefer to bind to Core Data object directly, but I haven't figured
    // out how to handle optional bindings yet
    @State private var hasExpiryDate = true
    @State private var expiryDate = Date()
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var statusMessage: StatusMessage
    @Binding var scanProductMode: ScanProductMode

    var body: some View {
        VStack {

            Spacer()

            if hasExpiryDate {
                DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                .labelsHidden()
            }


            Toggle(isOn: $hasExpiryDate) {
                Text("product has expiry date")
            }

            Button(action: {
                let product = Product(context: self.managedObjectContext)
                product.id = UUID()
                if let data = Camera.instance.captureHandler.data {
                    product.photo = data
                }
                if self.hasExpiryDate {
                    product.expiryDate = self.expiryDate
                }

                do {
                    try self.managedObjectContext.save()
                    self.statusMessage.info("Product saved.")
                } catch {
                    self.statusMessage.error(error.localizedDescription)
                    }
                scanProductMode = .takeSnapshot
            }) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add Product")
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(20)
            .padding()
        }
    }
}

