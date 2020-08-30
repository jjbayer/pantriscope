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

    @Published var message: String?
    @Published var status: StatusType = .info
}
