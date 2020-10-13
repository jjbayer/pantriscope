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
                
                print("dateString: \(dateString), format: \(format)")
                if let parsedDate = formatter.date(from: dateString) {

                    // Confidences are descending, so we can return immediately.
                    return ParsedExpiryDate(date: parsedDate, confidence: confidence)

                } else {
                    print("Cannot parse date from '\(dateString)' with format '\(format)'")
                }

            }
        }

        return ParsedExpiryDate()
    }

}
