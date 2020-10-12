//
//  StatusMessage.swift
//  pantry
//
//  Created by Joris on 30.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//
import SwiftUI

class StatusMessage: ObservableObject {

    enum StatusType {
        case debug
        case info
        case warning
        case error
    }

    typealias UndoAction = ()->Void

    @Published var text: String?
    @Published var status: StatusType = .info

    var undoAction: UndoAction?

    func info(_ message: String, undoAction: UndoAction? = nil) {
        status = .info
        text = message
        self.undoAction = undoAction
    }
    func error(_ message: String) { status = .error; text = message; self.undoAction = nil }

    func clear() {
        text = nil
        undoAction = nil
    }
}
