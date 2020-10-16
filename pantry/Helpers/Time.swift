//
//  Time.swift
//  pantry
//
//  Created by Joris on 16.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import Foundation

/// define as start of day
func normalize(_ date: Date) -> Date {
    Calendar.current.startOfDay(for: date)
}

/// Shortcut for today
func today() -> Date {
    normalize(Date())
}


func relativeDateDescription(_ date: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full

    return formatter.localizedString(for: normalize(date), relativeTo: today())
}
