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

    func addReminder(_ reminderTime: TimeInterval) {
        if let context = self.managedObjectContext {
            let reminder = Reminder(context: context)
            reminder.product = self
            reminder.timeBeforeExpiry = reminderTime
            print("Adding reminder for \(String(describing: self.id))")
            self.addToReminder(reminder)
            do { try context.save() } catch { print("Unable to save reminder: \(error)")}
        } else {
            print("Cannot add reminder to product without context")
        }
    }

    func hasReminder(_ reminderTime: TimeInterval) -> Bool {
        if let reminders = self.reminder {
            print("Product \(String(describing: self.id)) has reminders")
            let predicate = NSPredicate(format: "timeBeforeExpiry == \(reminderTime)")  // TODO: float comparison

            let hasIt = !(reminders.filtered(using: predicate).isEmpty)
            print("  Product has this reminder: \(hasIt)")

            return hasIt
        }

        return false
    }

    var expiryString: String? {

        var result: String? = nil

        if let delta = timeUntilExpiry, let date = expiryDate {
            if delta < 0 {
                let format = NSLocalizedString("expired %@", comment: "e.g. expired last week")
                result = String(format: format, relativeDateDescription(date))
            } else if delta == 0 {
                result = NSLocalizedString("expires today", comment: "")
            } else {
                let format = NSLocalizedString("expires %@", comment: "e.g. expires in two days")
                result = String(format: format, relativeDateDescription(date))
            }
        }

        return result
    }

    var expiryStringLong: String? {

        var result: String? = nil

        if let delta = timeUntilExpiry, let date = expiryDate {
            if delta < 0 {
                let format = NSLocalizedString("Product expired %@.", comment: "e.g. Product expired last week.")
                result = String(format: format, relativeDateDescription(date))
            } else if delta == 0 {
                result = NSLocalizedString("Product expires today.", comment: "")
            } else {
                let format = NSLocalizedString("Product expires %@.", comment: "e.g. Product expires in two days.")
                result = String(format: format, relativeDateDescription(date))
            }
        }

        return result
    }

    var addedStringLong: String {

        if let added = dateAdded {

            if added == today() {
                return NSLocalizedString("Added today.", comment: "")
            }

            let format = NSLocalizedString("Added %@.", comment: "e.g. Added two weeks ago.")
            return String(format: format, relativeDateDescription(added))
        } else {
            return NSLocalizedString("<no added date>", comment: "Should never happen")
        }
    }
}
