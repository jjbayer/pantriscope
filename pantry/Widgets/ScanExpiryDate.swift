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

    @State private var expiryDate = Date()
    @State private var confidence = 0.0  // Parser confidence
    @State private var dateWasSelected = false

    @Binding var scanProductMode: ScanProductMode
    @Binding var statusMessage: StatusMessage

    @Environment(\.managedObjectContext) var managedObjectContext

    let cornerRadius = CGFloat(10.0)

    var body: some View {
        VStack {
            backButton.padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            Spacer()
            controlPanel
        }
        .onAppear {
            print("expdate appear")
            Camera.instance.onFrame { frame in
                detectExpiryDate(sampleBuffer: frame, onSuccess: { parsed in
                    if parsed.confidence > confidence {
                        print("set parsed date \(parsed.date) with confidence \(parsed.confidence)")
                        expiryDate = parsed.date
                        confidence = parsed.confidence
                    }
                })
            }
        }
        .onDisappear {
            print("expdate gone")
            Camera.instance.clearFrameHandler()
        }
    }

    var backButton: some View {
        HStack {
            Button(action: {
                scanProductMode = .takeSnapshot
            }) {
                HStack { Image(systemName: "chevron.left"); Text("Back") }.padding()
            }
            Spacer()
        }
    }

    var controlPanel: some View {
        VStack {
            datePanel
            saveButton
        }
        .padding()
    }

    var labelText: String {
        if dateWasSelected {
            return "Expiry date:"
        } else {
            return "Detecting expiry date..."
        }
    }

    var datePanel: some View {
        VStack {
            DatePicker(labelText, selection: $expiryDate, displayedComponents: .date)
                .onTapGesture {
                    confidence = 0.0
                }
                .onChange(of: expiryDate, perform: { _ in
                    print("date changed ")
                    dateWasSelected = true
                })
                .padding()
                .background(Color.white)
                .cornerRadius(cornerRadius)
        }
    }

    var saveButton: some View {
        // TODO: disable button when not detected
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
            product.expiryDate = self.expiryDate

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
        .disabled(!dateWasSelected)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
        .foregroundColor(.white)
        .background(dateWasSelected ? Color.green : Color.gray)
        .cornerRadius(cornerRadius)
    }
}

