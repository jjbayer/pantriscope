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


func closestDate(from: Date, to: DateComponents) -> Date? {

    // If same, return
    if Calendar.current.date(from, matchesComponents: to) {

        return from
    }

    let next = Calendar.current.nextDate(after: from, matching: to, matchingPolicy: .nextTime)
    let prev = Calendar.current.nextDate(after: from, matching: to, matchingPolicy: .nextTime, direction: .backward)

    if let nextDate = next {
        if let prevDate = prev {
            let delta = { (date: Date) -> TimeInterval in abs(date.distance(to: from)) }

            return delta(nextDate) < delta(prevDate) ? nextDate : prevDate
        }

        return nextDate
    }

    if let prevDate = prev {

        return prevDate
    }

    return nil
}


func iso8601(date: Date) -> String {

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd'T'HHmmssZ"

    return formatter.string(from: date)
}
