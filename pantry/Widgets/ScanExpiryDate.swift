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
    @State private var currentConfidence = 0.0  // Parser confidence

    @Binding var scanProductMode: ScanProductMode
    @Binding var statusMessage: StatusMessage

    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        VStack {

            HStack {
                Button(action: {
                    scanProductMode = .takeSnapshot
                }) {
                    Text("< back")
                }
                .background(Color.white)
                .padding()
                Spacer()
            }



            Spacer()

            if hasExpiryDate {
                // TODO: set confidence to 2.0 when user selects date
                DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                .labelsHidden()
                    .background(Color.white)

            }


            Toggle(isOn: $hasExpiryDate) {
                Text("product has expiry date")
            }
            .padding()

            Button(action: {
                let product = Product(context: self.managedObjectContext)
                product.id = UUID()
                if let data = Camera.instance.captureHandler.data {
                    product.photo = data
                    detectText(imageData: data, onSuccess: { text in
                        product.detectedText = text

                        // Save, because async
                        do {
                            try self.managedObjectContext.save()
                            self.statusMessage.info("Product saved.")
                        } catch {
                            self.statusMessage.error(error.localizedDescription)
                        }
                    })
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
        .onAppear {
            print("expdate appear")
            Camera.instance.onFrame { frame in
                detectExpiryDate(sampleBuffer: frame, onSuccess: { parsed in
                    if parsed.confidence > currentConfidence {
                        print("set parsed date \(parsed.date) with confidence \(parsed.confidence)")
                        expiryDate = parsed.date
                        currentConfidence = parsed.confidence
                    }
                })
            }
        }
        .onDisappear {
            print("expdate gone")
            Camera.instance.clearFrameHandler()
        }
    }

}

