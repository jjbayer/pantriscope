//
//  Notifier.swift
//  pantry
//
//  Created by Joris on 16.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import UIKit
import BackgroundTasks
import CoreData


struct Notifier {

    static let taskId = "com.jorisbayer.pantry.notifier"

    static let minRelativeLifespan = 2.0
    static let reminderTimes = [0, 1, 7, 30].map { 1.0 * $0 * 24 * 3600 }

    static let instance = Notifier()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()

    func setup() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Notifier.taskId, using: nil) { task in
            self.sendOutReminders()
        }
    }

    func schedule() {

        print("Scheduling reminder background task...")

        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Notifier.taskId)
        let request = BGAppRefreshTaskRequest(identifier: Notifier.taskId)
        request.earliestBeginDate = Date()
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule reminder task: \(error)")
        }
    }

    func sendOutReminders() {
        print("Sending out reminders...")
        schedule() // Run next

        sendNotification(title: "Running scheduled background task", body: "Test body")

        let request = NSFetchRequest<Product>()
        request.entity = Product.entity()
        request.predicate = NSPredicate(format: "state like 'available'")
        var products: [Product]
        do {
            try products = context.fetch(request)
        } catch {
            print("Failed to fetch products for reminders")

            return
        }

        for product in products {
            scheduleRemindersForProduct(product: product)
        }
    }

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Notification granted: \(granted) with error: \(String(describing: error))")
        }
    }

    func sendNotification(title: String, body: String) {
        print("Sending notification...")
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false))
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              print("Failed to notify")
           }
        }
    }

    func scheduleRemindersForProduct(product: Product) {

        if let lifespan = product.lifespan, let timeUntilExpiry = product.timeUntilExpiry {
            for reminderTime in Notifier.reminderTimes {

                // No notification has to be scheduled if reminder time already exists
                if product.hasReminder(reminderTime) { break }

                if lifespan > reminderTime * Notifier.minRelativeLifespan && timeUntilExpiry <= reminderTime {

                    scheduleReminder(product, reminderTime)

                    break // one reminder is enough
                }
            }
        }
    }

    func scheduleReminder(_ product: Product, _ reminderTime: TimeInterval) {
        if let expiryString = product.expiryStringLong {
            sendNotification(
                title: expiryString,
                body: product.addedStringLong
            )
        } else {
            print("ERROR: Scheduling reminder for product without expiry date")
        }

    }
}



