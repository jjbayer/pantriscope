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
    guard let source = UIApplication.shared.windows.last?.rootViewController else {
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

    if let id = inventory.id, let name = inventory.name {

        let json = JSONEncoder()
        json.outputFormatting = .prettyPrinted
        json.dateEncodingStrategy = .iso8601

        let codable = CodableInventory(id: id, name: name, products: inventory.product)

        var result: Data
        do {
            result = try json.encode(codable)
        } catch {
            Logger().reportError(error: error)

            return false
        }

        let tempFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("inventory_\(name).json")

        do {
            try result.write(to: tempFileURL)
        } catch {
            Logger().reportError("Failed to write export: \(error.localizedDescription)")

            return false
        }

        return share(items: [tempFileURL])
    }

    return false
}
