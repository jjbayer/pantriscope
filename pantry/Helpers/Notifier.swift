//
//  Notifier.swift
//  pantry
//
//  Created by Joris on 16.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import UIKit
import CoreData
import BackgroundTasks


class ResponseReceiver: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                didReceive response: UNNotificationResponse,
                withCompletionHandler completionHandler:
                   @escaping () -> Void) {

        if let id = response.notification.request.content.userInfo["PRODUCT_ID"] as? String {
            // TODO: when we have inventories, go to the correct inventory
            print("Set product ID for navigation")
            Navigator.instance.selectedTabItem = .inventory
            Navigator.instance.selectedProductID = id
            Navigator.instance.dummy = true // HACK to make InventoryView scroll to correct product
        }
        completionHandler()
    }
}


struct Notifier {

    static let taskId = "com.jorisio.pantry.notifier"

    static let minRelativeLifespan = 2.0
    static let reminderTimes = [0, 1, 7, 30].map { 1.0 * $0 * 24 * 3600 }

    static let instance = Notifier()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()

    let receiver = ResponseReceiver()

    func setup() {

        BGTaskScheduler.shared.register(forTaskWithIdentifier: Notifier.taskId, using: nil) { task in
            self.runBackgroundTask(task: task as! BGAppRefreshTask)
        }

        UNUserNotificationCenter.current().delegate = receiver
    }

    func scheduleBackgroundTask() {

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

    func runBackgroundTask(task: BGAppRefreshTask) {

        scheduleBackgroundTask() // Run next

        sendOutReminders()

        task.setTaskCompleted(success: true)
    }

    func sendOutReminders() {
        print("Sending out reminders...")

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

    func sendNotification(title: String, body: String, fileURL: URL?, userInfo: [AnyHashable : Any], successFn: @escaping () -> ()) {
        print("Sending notification...")

        // TODO: localize
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.userInfo = userInfo

        if let url = fileURL {
            var attachment: UNNotificationAttachment
            do {
                try attachment = UNNotificationAttachment(identifier: "productImage", url: url)
                content.attachments.append(attachment)
            } catch {
                print("Unable to create attachment: \(error.localizedDescription)")
            }
        }

        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false))

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Failed to notify: \(error.localizedDescription)")
            } else {
                successFn()
            }
        }
    }

    func scheduleRemindersForProduct(product: Product) {

        if let lifespan = product.lifespan, let timeUntilExpiry = product.timeUntilExpiry {
            for reminderTime in Notifier.reminderTimes {

                // No notification has to be scheduled if reminder time already exists
                if product.hasReminder(reminderTime) { break }

                if lifespan >= reminderTime * Notifier.minRelativeLifespan && timeUntilExpiry <= reminderTime {

                    scheduleReminder(product, reminderTime)

                    break // one reminder is enough
                }
            }
        }
    }

    func scheduleReminder(_ product: Product, _ reminderTime: TimeInterval) {
        print("Schedule reminder for product \(String(describing: product.id))")
        if let expiryString = product.expiryStringLong, let id = product.id {

            var imageURL: URL? = nil
            if let imageData = product.photo {
                let imagePath = FileManager.default.temporaryDirectory.appendingPathComponent("image-\(id).jpg")
                do {
                    try imageData.write(to: imagePath)
                    imageURL = imagePath
                } catch {
                    print("Unable to write image")
                }
            }

            sendNotification(
                title: expiryString,
                body: product.addedStringLong,
                fileURL: imageURL,
                userInfo: ["PRODUCT_ID": id.uuidString],
                successFn: {
                    product.addReminder(reminderTime)
                }
            )
        } else {
            print("ERROR: Scheduling reminder for product without expiry date")
        }

    }
}



