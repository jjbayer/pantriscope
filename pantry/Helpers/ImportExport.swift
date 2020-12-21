//
//  ImportExport.swift
//  pantry
//
//  Created by Joris on 12/20/20.
//  Copyright © 2020 Joris. All rights reserved.
//
import os
import Foundation
import UIKit


/// From https://stackoverflow.com/a/59515229
func share(
    items: [Any],
    excludedActivityTypes: [UIActivity.ActivityType]? = nil
) -> Bool {
    // Use first window instead of last:
    // https://jeevatamil.medium.com/how-to-create-share-sheet-uiactivityviewcontroller-in-swiftui-cef64b26f073
    guard let source = UIApplication.shared.windows.first?.rootViewController else {
        return false
    }
    let vc = UIActivityViewController(
        activityItems: items,
        applicationActivities: nil
    )
    vc.excludedActivityTypes = excludedActivityTypes
    vc.popoverPresentationController?.sourceView = source.view
    source.present(vc, animated: true)

    return true
}


class CodableProduct: Codable {

    var id: UUID?
    var dateAdded: Date?
    var expiryDate: Date?
//    var photo: Data?
    var detectedText: String?

    init(product: Product) {
        self.id = product.id
        self.dateAdded = product.dateAdded
        self.expiryDate = product.expiryDate
//        self.photo = product.photo
        self.detectedText = product.detectedText
    }
}


class CodableInventory: Codable {
    var id: UUID
    var name: String
    var products: [CodableProduct]

    init(id: UUID, name: String, products: NSSet?) {
        self.id = id
        self.name = name
        self.products = []
        if let items = products {
            for item in items {
                if let product = item as? Product {
                    self.products.append(CodableProduct(product: product))
                }
            }
        }
    }
}


func export(inventory: Inventory) -> Bool {

    let logger = Logger(subsystem: App.name, category: "export")

    if let id = inventory.id, let name = inventory.name {

        let json = JSONEncoder()
        json.outputFormatting = .prettyPrinted
        json.dateEncodingStrategy = .iso8601

        let codable = CodableInventory(id: id, name: name, products: inventory.product)

        var result: Data
        do {
            result = try json.encode(codable)
        } catch {
            logger.reportError(error: error)

            return false
        }

        let basename = "\(App.name)_\(name)"

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(NSUUID().uuidString)
        let dirURL = tempURL.appendingPathComponent(basename)

        do {
            try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
        } catch {
            logger.reportError(error: error)

            return false
        }

        let tempFileURL = dirURL.appendingPathComponent("\(basename).json")

        do {
            try result.write(to: tempFileURL)
        } catch {
            logger.reportError(error: error)

            return false
        }

        // Write images
        if let items = inventory.product {
            for item in items {
                if let product = item as? Product {
                    if let id = product.id, let imageData = product.photo {
                        let imageURL = dirURL.appendingPathComponent("\(id).jpg")
                        do {
                            try imageData.write(to: imageURL)
                        } catch {
                            logger.warning("Failed to write product image: \(error.localizedDescription)")
                        }

                    }
                }
            }
        }

        // Finally, share the entire directory
        return share(items: [dirURL])
    }

    return false
}
