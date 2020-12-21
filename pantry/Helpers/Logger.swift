//
//  Logger.swift
//  pantry
//
//  Created by Joris on 12/20/20.
//  Copyright © 2020 Joris. All rights reserved.
//
import os
import Sentry

extension Logger {

    /// Write error to console and send to Sentry
    func reportError(_ message: String) {
        self.error("\(message)")
        SentrySDK.logLevel = .error
        SentrySDK.capture(message: message)
        SentrySDK.logLevel = .none
    }

    /// Write error to console and send to Sentry
    func reportError(error: Error) {
        self.error("\(error.localizedDescription)")
        SentrySDK.logLevel = .error
        SentrySDK.capture(message: "\(error.localizedDescription)")
        SentrySDK.logLevel = .none
    }

}

