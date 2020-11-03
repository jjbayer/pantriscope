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
        case success
        case warning
        case error
    }

    typealias UndoAction = ()->Void

    @Published var text: String?
    @Published var status: StatusType = .success

    @Published var undoAction: UndoAction?

    func success(_ message: String, undoAction: UndoAction? = nil) {
        alter(status: .success, text: message, undoAction: undoAction)

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.clear()
        }
    }
    func error(_ message: String) {
        alter(status: .error, text: message, undoAction: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.clear()
        }
    }

    func clear() {
        alter(status: .debug, text: nil, undoAction: nil)
    }

    func alter(status: StatusType, text: String?, undoAction: UndoAction?) {
        withAnimation {
            self.status = status
            self.text = text
            self.undoAction = undoAction
        }
    }
}
