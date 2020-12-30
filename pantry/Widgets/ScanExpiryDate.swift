//
//  ScanExpiryDate.swift
//  pantry
//
//  Created by Joris on 21.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI
import AVFoundation
import os



struct ScanExpiryDate: View {

    @State private var expiryDate = Date()
    @State private var confidence = 0.0  // Parser confidence
    @State private var dateWasDetected = false

    @State private var showDatePicker = false
    @State private var dateWasSetManually = false

    @Binding var scanProductMode: ScanProductMode
    @Binding var statusMessage: StatusMessage
    @Binding var imageData: Data?

    @EnvironmentObject var camera: Camera

    @Environment(\.managedObjectContext) var managedObjectContext

    let cornerRadius = CGFloat(10.0)

    private let logger = Logger(subsystem: App.name, category: "ScanExpiryDate")

    var body: some View {
        ZStack {

            if !dateWasSetManually {
                FocusArea(
                    aspectRatio: 1/3,
                    caption: Text("Scan expiry date")
                )
            }
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
            camera.onFrame { frame in

                guard !(dateWasSetManually || showDatePicker) else {
                    // No need to detect
                    return
                }

                if let device = camera.device {
                    if let parsed = TextDetector.instance.detectExpiryDate(
                        sampleBuffer: frame,
                        cameraPosition: device.position) {

                        if parsed.confidence > confidence {
                            expiryDate = parsed.date
                            dateWasDetected = true
                            confidence = parsed.confidence
                        }
                    }
                }
            }
        }
        .onDisappear {
            camera.clearFrameHandler()
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
                    dateWasDetected: $dateWasDetected,
                    dateWasSetManually: $dateWasSetManually,
                    showDatePicker: $showDatePicker,
                    saveAction: { useExpiryDate in self.save(useExpiryDate: useExpiryDate) }
                )
            }
        }
    }

    private func save(useExpiryDate: Bool) {
        let product = Product(context: self.managedObjectContext)
        product.id = UUID()
        product.inventory = Inventory.defaultInventory(self.managedObjectContext)
        product.dateAdded = Date()
        if let data = imageData {
            product.photo = data
            TextDetector.instance.detectText(imageData: data, onSuccess: { text in
                product.detectedText = text

                // Save, because async
                do {
                    try self.managedObjectContext.save()
                    self.statusMessage.success(NSLocalizedString("Product saved.", comment: ""))
                } catch {
                    logger.reportError("Error saving detected text")
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


