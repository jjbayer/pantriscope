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
import CoreData


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
    var detectedText: String?
    var state: String?

    init(product: Product) {
        self.id = product.id
        self.dateAdded = product.dateAdded
        self.expiryDate = product.expiryDate
        self.detectedText = product.detectedText
        self.state = product.state
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

    if let inventoryID = inventory.id, let inventoryName = inventory.name {

        let json = JSONEncoder()
        json.outputFormatting = .prettyPrinted
        json.dateEncodingStrategy = .iso8601

        let codable = CodableInventory(id: inventoryID, name: inventoryName, products: inventory.product)

        var result: Data
        do {
            result = try json.encode(codable)
        } catch {
            logger.reportError(error: error)

            return false
        }

        let now = iso8601(date: Date())

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(NSUUID().uuidString)
        let exportDirectory = tempURL.appendingPathComponent("\(App.name)_\(inventoryName)_\(now)")

        do {
            try FileManager.default.createDirectory(at: exportDirectory, withIntermediateDirectories: true)
        } catch {
            logger.reportError(error: error)

            return false
        }

        let tempFileURL = exportDirectory.appendingPathComponent("\(inventoryName).json")

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
                        let imageURL = exportDirectory.appendingPathComponent("\(id).jpg")
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
        return share(items: [exportDirectory])
    }

    return false
}


func importInventory(_ exportURL: URL, context: NSManagedObjectContext) -> Bool {

    let logger = Logger(subsystem: App.name, category: "import")

    let json = JSONDecoder()
    json.dateDecodingStrategy = .iso8601

    // FIXME: always imports default.json
    let jsonURL = exportURL.appendingPathComponent("\(Inventory.defaultName).json")

    var data: Data
    do {
        try data = Data(contentsOf: jsonURL)
    } catch {
        logger.reportError(error: error)

        return false
    }

    var codableInventory: CodableInventory
    do {
        try codableInventory = json.decode(CodableInventory.self, from: data)
    } catch {
        logger.reportError(error: error)

        return false
    }

    let inventory = Inventory(context: context)
    inventory.id = codableInventory.id
    inventory.name = codableInventory.name

    for codableProduct in codableInventory.products {
        let product = Product(context: context)
        product.inventory = inventory
        product.id = codableProduct.id
        product.dateAdded = codableProduct.dateAdded
        product.expiryDate = codableProduct.expiryDate
        product.state = codableProduct.state
        product.detectedText = codableProduct.detectedText

        if let productID = product.id {
            // Add image data
            let imagePath = exportURL.appendingPathComponent("\(productID).jpg").path
            let imageData = FileManager.default.contents(atPath: imagePath)
            product.photo = imageData
        }
    }

    do {
        try context.save()
    } catch {
        logger.reportError(error: error)

        return false
    }

    return true
}
