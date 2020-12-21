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

    var id: UUID
    var dateAdded: Date
    var expiryDate: Date?
    var image: Data

    init(id: UUID, dateAdded: Date, expiryDate: Date?, image: Data) {
        self.id = id
        self.dateAdded = dateAdded
        self.expiryDate = expiryDate
        self.image = image
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
                    if let id = product.id, let dateAdded = product.dateAdded, let image = product.photo {
                        self.products.append(
                            CodableProduct(
                                id: id,
                                dateAdded: dateAdded,
                                expiryDate: product.expiryDate,
                                image: image
                            )
                        )
                    }
                }
            }
        }
    }
}


func export(inventory: Inventory) -> Bool {

    if let id = inventory.id, let name = inventory.name {

        let json = JSONEncoder()
        json.outputFormatting = .prettyPrinted

        let codable = CodableInventory(id: id, name: name, products: inventory.product)

        if let result = try? json.encode(codable) {

            let tempFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("inventory_\(name).json")

            do {
                try result.write(to: tempFileURL)
            } catch {
                Logger().error("Failed to write export: \(error.localizedDescription)")

                return false
            }

            return share(items: [tempFileURL])
        }
    }

    return false
}
