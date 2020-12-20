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
    @State private var dateWasSelected = false

    @Binding var scanProductMode: ScanProductMode
    @Binding var statusMessage: StatusMessage
    @Binding var imageData: Data?

    @EnvironmentObject var camera: Camera

    @Environment(\.managedObjectContext) var managedObjectContext

    let cornerRadius = CGFloat(10.0)

    private let logger = Logger(subsystem: App.name, category: "ScanExpiryDate")

    var body: some View {
        ZStack {
            FocusArea(
                aspectRatio: 1/3,
                caption: Text("Scan expiry date")
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
            camera.onFrame { frame in
                if let device = camera.device {
                    if let parsed = detectExpiryDate(
                        sampleBuffer: frame,
                        cameraPosition: device.position) {

                        if parsed.confidence > confidence {
                            expiryDate = parsed.date
                            dateWasSelected = true // Why is this necessary? .onChange(expiryDate) should set it anyway
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
                    dateWasSelected: $dateWasSelected,
                    saveAction: { useExpiryDate in self.save(useExpiryDate: useExpiryDate) }
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


