//
//  AppDelegate.swift
//  pantry
//
//  Created by Joris on 19.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import UIKit
import CoreData
import Sentry


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        print("Init sentry...")
        SentrySDK.start { options in
            options.dsn = "https://a0724654ac474d5a9743af4653902222@o481683.ingest.sentry.io/5533788"
            #if DEBUG
            options.debug = true
            #else
            options.debug = false
            #endif
        }
        print("done.")

        Notifier.instance.setup()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

