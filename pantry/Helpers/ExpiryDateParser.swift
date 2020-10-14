//
//  ExpiryDateParser.swift
//  pantry
//
//  Created by Joris on 13.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//
import Foundation


struct ParsedExpiryDate {
    var date: Date = Date.distantPast
    var confidence: Double = 0.0
}

struct ExpiryDateParser {

    static let day = #"(([012]\d)|(3(0|1)))"#
    static let month = #"((0[1-9])|(1[0-2]))"#
    static let year = #"(20\d{2})"#
    static let yearShort = #"(\d{2})"#

    // TODO: localize date patterns. These are for common Austrian products
    // Make sure confidences descend
    static let datePatterns = [
        ("\(day)\\.\(month)\\.\(year)", "dd.MM.yyyy", 1.0),
        ("\(day)-\(month)-\(year)", "dd-MM-yyyy", 1.0),
        ("\(day)/\(month)/\(year)", "dd/MM/yyyy", 1.0),

        ("\(day)\\.\(month)\\.\(yearShort)", "dd.MM.yy", 0.9),
        ("\(day)-\(month)-\(yearShort)", "dd-MM-yy", 0.9),
        ("\(day)/\(month)/\(yearShort)", "dd/MM/yy", 0.9),

        ("\(month)\\.\(year)", "MM.yyyy", 0.6),
        ("\(month)-\(year)", "MM-yyyy", 0.6),
        ("\(month)/\(year)", "MM/yyyy", 0.6),

        ("\(day)\(month)\(year)", "ddMMyyyy", 0.5),
        ("\(day)\(month)\(yearShort)", "ddMMyy", 0.4),
    ]

    static let minDate = Date().addingTimeInterval(-5*365*24*3600)
    static let maxDate = Date().addingTimeInterval(20*365*24*3600)

    func parse(text: String) -> ParsedExpiryDate {

        for (pattern, format, confidence) in ExpiryDateParser.datePatterns {
            if let match = text.range(of: pattern, options: .regularExpression) {
                let dateString = String(text[match])

                let formatter = DateFormatter()
                formatter.dateFormat = format
                formatter.timeZone = TimeZone.current

                if var date = formatter.date(from: dateString) {

                    print("Parsed date \(date) (confidence: \(confidence))")

                    if !format.contains("d") {
                        // If only month given, use  last day of month:
                        let oneMonth = DateComponents(month: 1, day: -1)
                        if let alteredDate = Calendar.current.date(byAdding: oneMonth, to: date) {
                            date = alteredDate
                        } else {
                            print("Error pushing date to end of month: \(date)")
                        }
                    }

                    // Sanity check:
                    if date < ExpiryDateParser.minDate || date > ExpiryDateParser.maxDate {

                        return ParsedExpiryDate()
                    }

                    // Confidences are descending, so we can return immediately.
                    return ParsedExpiryDate(date: date, confidence: confidence)
                }
            }
        }

        return ParsedExpiryDate()
    }

}
