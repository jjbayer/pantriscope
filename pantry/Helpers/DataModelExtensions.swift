//
//  DataModelExtensions.swift
//  pantry
//
//  Created by Joris on 16.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//
import Foundation
import UIKit


extension Product {

    var lifespan: TimeInterval? {
        if let expiryDate = self.expiryDate, let dateAdded = self.dateAdded {

            return normalize(dateAdded).distance(to: normalize(expiryDate))
        }

        return nil
    }

    var timeUntilExpiry: TimeInterval? {
        if let expiryDate = self.expiryDate {

            return today().distance(to: normalize(expiryDate))
        }

        return nil
    }

    var timeSinceAdded: TimeInterval {
        return normalize(dateAdded!).distance(to: today())
    }

    func hasReminder(_ reminderTime: TimeInterval) -> Bool {
        // FIXME: check database here

        return false
    }

    var expiryString: String? {

        var result: String? = nil

        if let delta = timeUntilExpiry, let date = expiryDate {
            if delta < 0 {
                result = "expired \(relativeDateDescription(date))"
            } else if delta == 0 {
                result = "expires today"
            } else {
                result = "expires \(relativeDateDescription(date))"
            }
        }

        return result
    }

    var expiryStringLong: String? {

        var result: String? = nil

        if let delta = timeUntilExpiry, let date = expiryDate {
            if delta < 0 {
                result = "Product expired \(relativeDateDescription(date))."
            } else if delta == 0 {
                result = "Product expires today."
            } else {
                result = "Product expires \(relativeDateDescription(date))."
            }
        }

        return result
    }

    var addedStringLong: String {
        return "Added \(relativeDateDescription(dateAdded!))."
    }
}
