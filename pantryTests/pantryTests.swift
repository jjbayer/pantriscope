//
//  pantryTests.swift
//  pantryTests
//
//  Created by Joris on 19.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import XCTest
@testable import Plenti

class pantryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExpiryDateParser() throws {

        XCTAssertEqual(
            ExpiryDateParser().parse(text: "31.12.2021").date,
            makeDate(2021, 12, 31)
        )

        XCTAssertEqual(
            ExpiryDateParser().parse(text: "17.10.20").date,
            makeDate(2020, 10, 17)
        )

        XCTAssertEqual(ExpiryDateParser().parse(text: "0010").confidence, 0.0)
        // Do not accept expiry dates from the previous century
        XCTAssertEqual(
            ExpiryDateParser().parse(text: "31.12.1999").confidence,
            0.0
        )
        XCTAssertEqual(
            ExpiryDateParser().parse(text: "010158").confidence, 0.0
        )
        XCTAssertEqual(
            ExpiryDateParser().parse(text: "31.12.5158").confidence, 0.0
        )

    }

    func testClosestDate() throws {

        // Exact date will always be exact date
        XCTAssertEqual(
            closestDate(from: makeDate(2020, 12, 18), to: DateComponents(year: 2005, month: 7, day: 18)),
            makeDate(2005, 7, 18)
        )

        // Yesterday
        XCTAssertEqual(
            closestDate(from: makeDate(2020, 12, 17), to: DateComponents(month: 12, day: 16)),
            makeDate(2020, 12, 16)
        )

        // Today
        XCTAssertEqual(
            closestDate(from: makeDate(2020, 12, 17), to: DateComponents(month: 12, day: 17)),
            makeDate(2020, 12, 17)
        )

        // Tomorrow
        XCTAssertEqual(
            closestDate(from: makeDate(2020, 12, 17), to: DateComponents(month: 12, day: 18)),
            makeDate(2020, 12, 18)
        )

        // Next year
        XCTAssertEqual(
            closestDate(from: makeDate(2020, 12, 17), to: DateComponents(month: 1, day: 4))!,
            makeDate(2021, 1, 4)
        )

        // Previous year
        XCTAssertEqual(
            closestDate(from: makeDate(2021, 1, 4), to: DateComponents(month: 12, day: 17))!,
            makeDate(2020, 12, 17)
        )
    }

    private func makeDate(_ year: Int, _ month: Int, _ day: Int) -> Date {
        return Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
    }

}
