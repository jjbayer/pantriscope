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
            menu
            Spacer()
            controlPanel
        }
        .padding()
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

    var menu: some View {
        HStack {
            Button(action: {
                scanProductMode = .takeSnapshot
            }) {
                HStack { Image(systemName: "chevron.left"); Text("Back") }
            }
            Spacer()

        }
    }

    var controlPanel: some View {
        VStack {
            fastForward
            datePanel
            saveButton
        }
    }

    var fastForward: some View {
        HStack {
            Spacer()
            Button(action: { self.save(useExpiryDate: false) }) {
                HStack {
                    Text("Save without expiry date ")
                    Image(systemName: "chevron.forward.2")
                }
            }
        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
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
                    dateWasSelected = true
                })
                .padding()
                .background(Color.white)
                .cornerRadius(cornerRadius)
        }
    }

    var saveButton: some View {
        Button(action: { self.save(useExpiryDate: true) }) {
            HStack {
                Image(systemName: "plus.circle")
                Text("Add Product")
            }
        }
        .disabled(!dateWasSelected)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
        .foregroundColor(.white)
        .background(dateWasSelected ? App.Colors.primary : App.Colors.note)
        .cornerRadius(cornerRadius)
    }

    private func save(useExpiryDate: Bool) {
        let product = Product(context: self.managedObjectContext)
        product.id = UUID()
        product.dateAdded = Date()
        if let data = Camera.instance.captureHandler.data {
            product.photo = data
            detectText(imageData: data, onSuccess: { text in
                product.detectedText = text

                // Save, because async
                do {
                    try self.managedObjectContext.save()
                    self.statusMessage.success("Product saved.")
                } catch {
                    print("Error saving detected text")
                }
            })
        }
        if useExpiryDate {
            product.expiryDate = self.expiryDate
        }

        do {

            try self.managedObjectContext.save()
            self.statusMessage.success("Product saved.")
        } catch {
            self.statusMessage.error("Error saving product") // TODO: report
        }
        scanProductMode = .takeSnapshot
    }
}

