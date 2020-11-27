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
    @Binding var imageData: Data?

    @Environment(\.managedObjectContext) var managedObjectContext

    let cornerRadius = CGFloat(10.0)

    var body: some View {
        ZStack {
            FocusArea(
                aspectRatio: 1/3,
                caption: dateWasSelected ? Text(dateFormat) : Text("Scan expiry date")
            )
            interactionLayer
        }
    }

    var interactionLayer: some View {
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
        HStack(alignment: .top) {
        
            Button(action: {
                scanProductMode = .takeSnapshot
            }) {
                HStack { Image(systemName: "chevron.left"); Text("Back") }
            }
            Spacer()

            if let data = imageData {
                ProductThumbnail(imageData: data)
            }
        }
    }

    var controlPanel: some View {
        VStack {
            Spacer()
            if let _ = imageData {
                ExpiryDateOptions(
                    expiryDate: $expiryDate,
                    canSave: $dateWasSelected,
                    saveAction: { self.save(useExpiryDate: true) }, fastForwardAction: { self.save(useExpiryDate: false) }
                )
            }
        }
    }

    private func save(useExpiryDate: Bool) {
        let product = Product(context: self.managedObjectContext)
        product.id = UUID()
        product.dateAdded = Date()
        if let data = imageData {
            product.photo = data
            detectText(imageData: data, onSuccess: { text in
                product.detectedText = text

                // Save, because async
                do {
                    try self.managedObjectContext.save()
                    self.statusMessage.success(NSLocalizedString("Product saved.", comment: ""))
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
            self.statusMessage.success(NSLocalizedString("Product saved.", comment: ""))

            Notifier.instance.requestAuthorization()
            
        } catch {
            self.statusMessage.error(NSLocalizedString("Error saving product", comment: "")) // TODO: report
        }
        scanProductMode = .takeSnapshot
    }

    private var dateFormat: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none

        return formatter.string(from: expiryDate)
    }
}


