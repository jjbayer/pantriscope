//
//  StatusMessage.swift
//  pantry
//
//  Created by Joris on 30.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//
import SwiftUI

struct StatusMessage {

    enum StatusType {
        case debug
        case info
        case warning
        case error
    }

    typealias UndoAction = ()->Void

    var text: String?
    var status: StatusType = .info

    var undoAction: UndoAction?

    mutating func info(_ message: String, undoAction: UndoAction? = nil) {
        status = .info
        text = message
        self.undoAction = undoAction
    }
    mutating func error(_ message: String) { status = .error; text = message; self.undoAction = nil }

    mutating func clear() {
        text = nil
        undoAction = nil
    }
}
