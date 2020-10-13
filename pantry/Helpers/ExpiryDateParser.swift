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

    // TODO: localize date patterns. These are for common Austrian products
    // Make sure confidences descend
    static let datePatterns = [
        (#"(\d{2}\.\d{2}\.\d{4})"#, "dd.MM.yyyy", 1.0),
        (#"(\d{2}-\d{2}-\d{4})"#, "dd-MM-yyyy", 1.0),
        (#"(\d{2}/\d{2}/\d{4})"#, "dd/MM/yyyy", 1.0),
        (#"(\d{2}\.d{2}\.\d{2})"#, "dd.MM.yyyy", 0.9),
        (#"(\d{2}-\d{2}-\d{2})"#, "dd-MM-yyyy", 0.9),
        (#"(\d{2}/\d{2}/\d{2})"#, "dd/MM/yyyy", 0.9),
        (#"(\d{2}/\d{4})"#, "MM/yyyy", 0.6),
        (#"(\d{2}-\d{4})"#, "MM-yyyy", 0.6),
        (#"(\d{2}\.\d{4})"#, "MM.yyyy", 0.6),
        (#"(\d{8})"#, "ddMMyyyy", 0.55),
        (#"(\d{6})"#, "ddMMyy", 0.5),
    ]

    func parse(text: String) -> ParsedExpiryDate {

        for (pattern, format, confidence) in ExpiryDateParser.datePatterns {
            if let match = text.range(of: pattern, options: .regularExpression) {
                let dateString = String(text[match])

                let formatter = DateFormatter()
                formatter.dateFormat = format
                formatter.timeZone = TimeZone.current

                if var date = formatter.date(from: dateString) {

                    if !format.contains("d") {
                        // If only month given, use  last day of month:
                        let oneMonth = DateComponents(month: 1, day: -1)
                        if let alteredDate = Calendar.current.date(byAdding: oneMonth, to: date) {
                            date = alteredDate
                        } else {
                            print("Error pushing date to end of month: \(date)")
                        }
                    }

                    // Confidences are descending, so we can return immediately.
                    return ParsedExpiryDate(date: date, confidence: confidence)
                }
            }
        }

        return ParsedExpiryDate()
    }

}
