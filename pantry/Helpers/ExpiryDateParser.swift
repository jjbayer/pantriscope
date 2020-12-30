//
//  ExpiryDateParser.swift
//  pantry
//
//  Created by Joris on 13.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//
import Foundation
import os


struct ParsedExpiryDate {
    var date: Date = Date.distantPast
    var confidence: Double = 0.0
}

struct ExpiryDateParser {

    static let allowedSurrounding = ["-"]
    static let allowedSurroundingCharacters = CharacterSet(["-"])

    static let day = #"(([012]\d)|(3(0|1)))"#
    static let month = #"((0[1-9])|(1[0-2]))"#
    static let year = #"(20\d{2})"#
    static let yearShort = #"(\d{2})"#

    static let datePatterns = initDatePatterns()

    static let minDate = Date().addingTimeInterval(-5*365*24*3600)
    static let maxDate = Date().addingTimeInterval(20*365*24*3600)

    private let logger = Logger(subsystem: App.name, category: "ExpiryDateParser")

    func parse(text: String) -> ParsedExpiryDate {

        var result = ParsedExpiryDate()
        for line in text.split(separator: "\n") {
            let lineResult = parseLine(text: String(line))
            if lineResult.confidence > result.confidence {
                result = lineResult
            }
        }

        return result
    }

    func parseLine(text: String) -> ParsedExpiryDate {

        for (pattern, format, confidence) in ExpiryDateParser.datePatterns {
            if let match = text.range(of: pattern, options: .regularExpression) {
                let dateString = String(text[match])
                    .trimmingCharacters(in: ExpiryDateParser.allowedSurroundingCharacters)

                let formatter = DateFormatter()
                formatter.dateFormat = format
                formatter.timeZone = TimeZone.current

                if var date = formatter.date(from: dateString) {

                    if !format.contains("y") {
                        // If no year given, use closest:
                        let components = Calendar.current.dateComponents([.month, .day], from: date)
                        if let alteredDate = closestDate(from: today(), to: components) {

                            date = alteredDate
                        }
                    } else if !format.contains("d") {
                        // If only month given, use  last day of month:
                        let oneMonth = DateComponents(month: 1, day: -1)
                        if let alteredDate = Calendar.current.date(byAdding: oneMonth, to: date) {
                            date = alteredDate
                        } else {
                            logger.reportError("Error pushing date to end of month: \(date)")
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

    static func initDatePatterns() -> [(String, String, Double)] {

        let allowedSurroundingRegex = allowedSurrounding.joined(separator: "|")
        let begin = "(^|\\s|\(allowedSurroundingRegex))"
        let end = "($|\\s|\(allowedSurroundingRegex))"

        // TODO: localize date patterns. These are for common Austrian products
        // NOTE: Make sure confidences descend
        return [
            ("\(day)\\.\(month)\\.\(year)", "dd.MM.yyyy", 1.0),
            ("\(day)-\(month)-\(year)", "dd-MM-yyyy", 1.0),
            ("\(day)/\(month)/\(year)", "dd/MM/yyyy", 1.0),
            ("\(day) \(month) \(year)", "dd MM yyyy", 0.95),

            ("\(day)\\.\(month)\\.\(yearShort)", "dd.MM.yy", 0.9),
            ("\(day)-\(month)-\(yearShort)", "dd-MM-yy", 0.9),
            ("\(day)/\(month)/\(yearShort)", "dd/MM/yy", 0.9),
            ("\(day) \(month) \(yearShort)", "dd MM yy", 0.85),

            ("\(month)\\.\(year)", "MM.yyyy", 0.6),
            ("\(month)-\(year)", "MM-yyyy", 0.6),
            ("\(month)/\(year)", "MM/yyyy", 0.6),
            ("\(month) \(year)", "MM yyyy", 0.55),

            ("\(day)\(month)\(year)", "ddMMyyyy", 0.5),
            ("\(day)\(month)\(yearShort)", "ddMMyy", 0.4),

            ("\(day)\\. ?\(month)\\.", "dd.MM.", 0.3),
            ("\(day)\\. ?\(month)", "dd.MM", 0.25),
        ].map { (pattern, format, confidence) in

            // Make sure that dates are delimited by non-words:
            ("\(begin)\(pattern)\(end)", format, confidence)

        }
    }
}


